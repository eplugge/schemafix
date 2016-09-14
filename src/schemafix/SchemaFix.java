/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package schemafix;

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Application;
import javafx.stage.Stage;
import org.apache.commons.cli.BasicParser;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.io.FileUtils;

import schemafix.views.*;
import schemafix.controllers.*;
import schemafix.models.*;

/**
 *
 * @author eelco
 */
public class SchemaFix extends Application {    
    static Options options = new Options();
    
    @Override
    public void start(Stage primaryStage) {
        LauncherModel m = new LauncherModel();
        LauncherView v = new LauncherView();
        LauncherController c = new LauncherController(m,v);        
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        String arguments[] = null;        
        arguments = args;
        
        options.addOption("g", "gold-schema", true, "Set the gold schema file to compare against");
        options.addOption("c", "corrupted-schema", true, "Set the corrupted schema file to be compared");
        options.addOption("o", "out", true, "Set the out file to write the results to (optional, default: STDOUT)");
        options.addOption("h", "help", false, "Shows this help");
        
        // launch GUI if no parameters are given
        if(args.length < 1) {
            launch(args);    
        } else {
            CommandLineParser parser = new BasicParser();
            CommandLine cmd = null;
            
            try {
                cmd = parser.parse(options, args);
                if(cmd.hasOption("h")){
                    help();
                    System.exit(0);
                }
                if(cmd.hasOption("g") && cmd.hasOption("c") && !cmd.getOptionValue("g").isEmpty() && !cmd.getOptionValue("c").isEmpty()) {
                    LauncherModel m = new LauncherModel();
                    String res = m.fix(cmd.getOptionValue("c"), cmd.getOptionValue("g"), 1);
                    if(cmd.hasOption("o") && !cmd.getOptionValue("o").isEmpty()) {
                        File f = new File(cmd.getOptionValue("o"));
                        FileUtils.writeStringToFile(f, res);
                    } else {
                        System.out.println(res);
                    }
                    System.exit(0);
               } else {
                    help();
                    System.exit(0);
                }
            } catch (ParseException e) {
                
            } catch (IOException ex) {
                Logger.getLogger(SchemaFix.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
    }
    
    private static void help(){
        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp("SchemaFix.jar", options);
    }
    
}
