/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package schemafix.models;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

/**
 *
 * @author eelco
 */
public class LauncherModel {

    public ObservableList<String> getSchemaList() {
        // System.out.println(getClass().getClassLoader().getResource("resources/r9.0.0.0-schema.sql"));
        ObservableList<String> res = FXCollections.observableArrayList();
        
        res.add("r5.7.0-schema.sql");
        res.add("r5.7.1-schema.sql");
        res.add("r5.7.6-schema.sql");
        res.add("r5.8.0-schema.sql");
        res.add("r5.8.5-schema.sql");
        res.add("r5.9.0-schema.sql");
        res.add("r5.9.1-schema.sql");
        res.add("r5.9.2-schema.sql");
        res.add("r6.0.0-schema.sql");
        res.add("r7.0.0-schema.sql");
        res.add("r7.1.0-schema.sql");
        res.add("r7.5.0-schema.sql");
        res.add("r7.5.0b-schema.sql");
        res.add("r7.5.1.0-schema.sql");
        res.add("r8.0.0-schema.sql");
        res.add("r8.0.1.0-schema.sql");
        res.add("r8.5.0.0-schema.sql");
        res.add("r9.0.0.0-schema.sql");
        res.add("r9.0.1.0-schema.sql");
        res.add("r9.0.1.1a-schema.sql");
        res.add("r9.1.0.0-schema.sql");
        res.add("Load from file...");
        return res;
    }

    public void readSourceSchema(String s){
        ClassLoader loader = LauncherModel.class.getClassLoader();
        InputStream in = loader.getResourceAsStream("resources/"+s);
        BufferedReader rdr = new BufferedReader(new InputStreamReader(in));
        String line;
        try {
            while ((line = rdr.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException ex) {
            Logger.getLogger(LauncherModel.class.getName()).log(Level.SEVERE, null, ex);
        }
        try {
            rdr.close();
        } catch (IOException ex) {
            Logger.getLogger(LauncherModel.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public String getSourceUri(String s){
        String res = getClass().getClassLoader().getResource("resources/"+s).toString();
        return res;
    }

    public String fix(String broken, String source, int external) throws FileNotFoundException, IOException {
        /* Temporary line holders */
        String line, tableName = null;
        Map<String,String> lh = new HashMap<String,String>();
        String res = "";
        /* For broken input file */
        File fileBroken = new File(broken);
        BufferedReader brBroken = new BufferedReader(new FileReader(fileBroken));
        /* For source file */
        BufferedReader brSource = null;
        if(external == 1) {
            File fileSource = new File(source);
            brSource = new BufferedReader(new FileReader(fileSource));
        } else {
            ClassLoader cl = LauncherModel.class.getClassLoader();
            InputStream is = cl.getResourceAsStream("resources/"+source);
            brSource = new BufferedReader(new InputStreamReader(is));            
        }
        /* Create hashmaps */
        Map<String,Map<String,String>> bh = new HashMap<String, Map<String,String>>();       // example: mi_device, <id,bigint(20) not null etc>
        Map<String,Map<String,String>> sh = new HashMap<String, Map<String,String>>();      // new HashMap<String,Map<String,String>>();       // example: mi_device, <property, unique key this and that>
        
        bh = sqlToMap(brBroken);
        sh = sqlToMap(brSource);
        
        res = res.concat("SET foreign_key_checks = 0;\n");
        for(String k : bh.keySet()) {
            if(sh.containsKey(k) && sh.get(k) == bh.get(k)) {
            }
            else if(!sh.containsKey(k)) {
                res = res.concat("DROP TABLE " + k + ";\n");
                continue;
            }
            // if table exists but columns are different, check for null
            else if(sh.containsKey(k) && sh.get(k) != null) {
                Map<String,String> behm = bh.get(k);
                Map<String,String> sehm = sh.get(k);
                for(String key : behm.keySet()) {
                    

                    
                    // if key doesn't exist in sh, then delete. ensure its a column
                    if(!sehm.containsKey(key) && !key.startsWith("PROPERTY")) {
                        res = res.concat("ALTER TABLE " + k + " DROP COLUMN " + key+ ";\n");
                    }
                    // if key does exist, compare values
                    if(sehm.containsKey(key) && !key.startsWith("PROPERTY")) {
                        //skip if identical
                        if(sehm.get(key).equals(behm.get(key))) {
                            // no action needed
                        }
                        //modify column if different
                        if(!sehm.get(key).equals(behm.get(key))){
                            res = res.concat("ALTER TABLE " + k + " MODIFY " + key + " " + sehm.get(key)+ ";\n");
                        }   
                    }
                    // if key does exist, compare values
                    if(key.startsWith("PROPERTY")) {
                        if(sehm.containsValue(behm.get(key))) {
                            ///System.out.println("property is identical: " + behm.get(key) + " and " + sehm.get(key));
                        }
                        if(!sehm.containsValue(behm.get(key))) {
                            res = res.concat("ALTER TABLE " + k + " DROP " + getKeyType(behm.get(key)) + " " + getKeyName(behm.get(key))+ ";\n");
                        }                       
                    }
                }
            }
        }

        /* Do the reverse, add what's here and isn't in bh */
        
        for(String k : sh.keySet()) {
            Map<String,String> behm = bh.get(k);
            Map<String,String> sehm = sh.get(k);
            
            if(!bh.containsKey(k)) {
                // add entire table
                String q = "CREATE TABLE " + k + " (";
                for(String key : sehm.keySet()) {
                    if(!key.startsWith("PROPERTY")) {
                        q = q + "`"+key+"` " + sehm.get(key) + ",";
                    }
                    if(key.startsWith("PROPERTY")) {
                        q = q + sehm.get(key) + ",";
                    }
                }
                q = strip(q) + ");";
                
                res = res.concat(q+"\n");
            }
            // table exists, now check columns
            if(bh.containsKey(k)) {
                for(String key : sehm.keySet()) {
                    // bh has table, but doesn't have column
                    if(!behm.containsKey(key) && !key.startsWith("PROPERTY")) {
                        res = res.concat("ALTER TABLE " + k + " ADD COLUMN " + key + " " + sehm.get(key)+ ";\n");
                    }
                    // bh has table, 
                    if(key.startsWith("PROPERTY") && behm.containsValue(sehm.get(key))) {
                        // do nothing
                    }
                    // bh table exists, but doesn't have the property given
                    if(key.startsWith("PROPERTY") && !behm.containsValue(sehm.get(key))) {
                        res = res.concat("ALTER TABLE " + k + " ADD " + sehm.get(key)+ ";\n");
                    }
                }
            }
            
        }
        res = res.concat("SET foreign_key_checks = 1;\n");
        return res;
    }

            
    private Map<String,Map<String,String>> sqlToMap(BufferedReader b) throws IOException {
        int counter = 0;
        String line = null;
        String tableName = null;
        Map<String,String> lh = null;
        Map<String,Map<String,String>> res = new HashMap<String,Map<String,String>>();
        while((line = b.readLine()) != null) {
            if(line.isEmpty()) {
                continue;
            }
            // trim any leading whitespace
            line = line.trim();
            if(line.startsWith("CREATE TABLE")) {
                tableName = getTableName(line);
                lh = new HashMap<String,String>();
            }
            else if(!line.endsWith(";")) {
                // Dealing with a column definition
                if(line.startsWith("`")) {
                    String cn = getColumnName(line);
                    String np = getColumnProperties(line);
                    lh.put(cn, np);
                // Dealing with column property
                } else {
                    lh.put("PROPERTY"+ ++counter, line);
                }
            }
            else if(line.endsWith(";")) {
                // dealing with end of the table
                res.put(tableName, lh);               
            }
        }   
        return res;
    }
   
    private String getTableName(String q){
        String res;
        int first = q.indexOf("`");
        int second = q.indexOf("`", first+1);
        res = q.substring(first+1, second);
        return res;
    }
    
    private String getColumnName(String q){
        String res;
        int first = q.indexOf("`");
        int second = q.indexOf("`", first+1);
        res = q.substring(first+1, second);
        return res;        
    }
    
    private String getColumnProperties(String q){
        int first = q.indexOf("`");
        int second = q.indexOf("`", first+1);
        int start = second+1;
        String res = q.substring(start).trim();
        return res;
    }
    
    private List<String> getFields(String q){
        String[] lines = q.split("\n");
        List<String> res = new ArrayList<>();
        for(String s : lines) {
            if(s.startsWith("CREATE TABLE")) {
                continue;
            }
            if(s.endsWith(";")) {
                continue;
            }
            else {
                res.add(s);
            }
        }
        return res;
    }
    
    public String strip(String str) {
        if (str != null && str.length() > 0) {
          str = str.substring(0, str.length()-1);
        }
        return str;
    }    

    private String getKeyName(String q) {
        String res;
        int keyLocation;
        int first;
        int second;
        // detect location of key         
        if(q.contains("FOREIGN KEY")) {
            keyLocation = q.indexOf("CONSTRAINT");
        } else {
            keyLocation = q.indexOf("KEY");
        }
        first = q.indexOf("`",keyLocation+1);
        second = q.indexOf("`",first+1);
        res = q.substring(first+1,second);
        return res;
    }

    private String getKeyType(String q) {
        String res;
        if(q.contains("FOREIGN KEY")) {
            res = "FOREIGN KEY";
        } else if (q.contains("PRIMARY KEY")) {
            res = "PRIMARY KEY";
        } else {
            res = "KEY";
        }
        return res;
    }
    
}
