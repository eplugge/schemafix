/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package schemafix.views;

import javafx.event.EventHandler;
import javafx.geometry.HPos;
import javafx.geometry.Pos;
import javafx.geometry.VPos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.RowConstraints;
import javafx.stage.Stage;

/**
 *
 * @author eelco
 */
public class ResultView {
    TextField tf_result = new TextField();
    Button btn_close = new Button("Close");
    TextArea ta_result = new TextArea();
    
    
    Stage stage = new Stage();
    
    public ResultView() {
        /* Create the root pane to hold the items */
        GridPane pane = new GridPane();
        
        /* Specify pane parameters */
        pane.setAlignment(Pos.CENTER);
        //pane.setGridLinesVisible(true);
        pane.setVgap(15);
        pane.setHgap(15);
        
        /* Add contents to pane */
        pane.add(ta_result, 0,0,1,1);
        pane.add(btn_close,0,1,1,1);
        
        /* Style contents accordingly */
        GridPane.setHalignment(ta_result,HPos.CENTER);
        GridPane.setValignment(ta_result,VPos.CENTER);
        GridPane.setHalignment(btn_close,HPos.CENTER);
        
        ta_result.setMaxWidth(Double.MAX_VALUE);
        ta_result.setMaxHeight(Double.MAX_VALUE);
        btn_close.setMaxWidth(Double.MAX_VALUE);
        
        /* Add Column Constraints */
        ColumnConstraints c100 = new ColumnConstraints();
        RowConstraints c90 = new RowConstraints();
        RowConstraints c10 = new RowConstraints();
        c90.setPercentHeight(90);
        c10.setPercentHeight(10);
        c100.setPercentWidth(100);
        pane.getColumnConstraints().addAll(c100);
        pane.getRowConstraints().addAll(c90,c10);
        
        /* Create the scene to hold the pane */
        Scene launchScene = new Scene(pane, 1200,600);
        
        /* Set up the stage to hold the scene */
        stage.setScene(launchScene);
        stage.setTitle("MobileIron Schema Fixer Output");
        stage.getIcons().add( new Image(ResultView.class.getResourceAsStream( "/resources/ninja_sword.png" )));
        stage.show();
    }
    
    public void setBtnCloseHandler(EventHandler e) {
        btn_close.setOnAction(e);
    }

    public void setResult(String r){
        String[] res = r.split("\n");
        ta_result.setText(r);
    }
    
    public void closeWindow() {
        stage.close();
    }    
}
