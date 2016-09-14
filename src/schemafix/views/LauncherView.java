/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package schemafix.views;

import javafx.collections.ObservableList;
import javafx.event.EventHandler;
import javafx.geometry.HPos;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.geometry.VPos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;

/**
 *
 * @author eelco
 */
public class LauncherView {
    Label lbl_source = new Label("Source Schema:");
    Label lbl_faulty   = new Label("Faulty Schema:");
    Label lbl_empty = new Label("");
    ComboBox cmb_source = new ComboBox();
    TextField tf_faulty = new TextField();
    Button btn_analyze = new Button("Analyze");
    Button btn_close = new Button("Close");
    
    
    Stage stage = new Stage();
    
    public LauncherView() {
        /* Create the root pane to hold the items */
        GridPane pane = new GridPane();
        
        /* Specify pane parameters */
        pane.setAlignment(Pos.CENTER);
        //pane.setGridLinesVisible(true);
        pane.setVgap(15);
        pane.setHgap(10);
        
        /* Add contents to pane */
        pane.add(lbl_faulty, 1,0,1,1);
        pane.add(tf_faulty,2,0,1,1);
        pane.add(lbl_source,1,1,1,1);
        pane.add(cmb_source,2,1,1,1);
        pane.add(lbl_empty,0,2,2,1);
        pane.add(btn_analyze,1,3,1,1);
        pane.add(btn_close,2,3,1,1);
        
        /* Style contents accordingly */
        GridPane.setHalignment(lbl_faulty,HPos.CENTER);
        GridPane.setHalignment(tf_faulty,HPos.CENTER);
        GridPane.setHalignment(lbl_source,HPos.CENTER);
        GridPane.setHalignment(cmb_source,HPos.CENTER);
        GridPane.setHalignment(btn_analyze,HPos.CENTER);
        GridPane.setHalignment(btn_close,HPos.CENTER);
        
        tf_faulty.setMaxWidth(Double.MAX_VALUE);
        cmb_source.setMaxWidth(Double.MAX_VALUE);
        btn_analyze.setMaxWidth(Double.MAX_VALUE);
        btn_close.setMaxWidth(Double.MAX_VALUE);

        //GridPane.setMargin(lbl_conStatus, new Insets(0, 10, 0, 0));
        
        /* Add Column Constraints */
        ColumnConstraints c10 = new ColumnConstraints();
        ColumnConstraints c25 = new ColumnConstraints();
        ColumnConstraints c65 = new ColumnConstraints();
        ColumnConstraints c45 = new ColumnConstraints();
        
        c10.setPercentWidth(10);
        c25.setPercentWidth(25);
        c65.setPercentWidth(65);
        c45.setPercentWidth(45);
        pane.getColumnConstraints().addAll(c10,c25,c65,c10);
        
        /* Create the scene to hold the pane */
        Scene launchScene = new Scene(pane, 500,250);
        
        /* Set up the stage to hold the scene */
        stage.setScene(launchScene);
        stage.setTitle("MobileIron Schema Fixer");
        stage.getIcons().add( new Image( LauncherView.class.getResourceAsStream( "/resources/ninja_sword.png" ))); 
        stage.show();
    }
    
    public void setBtnAnalyzeHandler(EventHandler e){
        btn_analyze.setOnAction(e);
    }
    
    public void setBtnCloseHandler(EventHandler e) {
        btn_close.setOnAction(e);
    }
    
    public void setTfClickHandler(EventHandler e){
        tf_faulty.setOnMouseClicked(e);
    }
    
    public void setCmbClickHandler(EventHandler e){
        cmb_source.setOnAction(e);
    }
    
    public void setTfUri(String s){
        tf_faulty.setText(s);
    }  
    
    public String getTfUri(){
        return tf_faulty.getText();
    }
    
    public void setCmbUri(String v){
        cmb_source.setValue(v);
    }
    
    public void setCmbSelection(String s){
        cmb_source.setValue(s);
    }
    
    public String getCmbUri(){
        if(cmb_source.getItems().isEmpty()) {
            return "";
        } else return cmb_source.getValue().toString();
    }
    
    public void fillCmbSchema(ObservableList<String> l) {
        cmb_source.setItems(l);
    }

    public void closeWindow() {
        stage.close();
    }
  
}
