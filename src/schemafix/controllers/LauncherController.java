/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package schemafix.controllers;

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.collections.ObservableList;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import schemafix.models.LauncherModel;
import schemafix.models.ResultModel;
import schemafix.views.LauncherView;
import schemafix.views.ResultView;

/**
 *
 * @author eelco
 */
public class LauncherController {
    private LauncherView v;
    private LauncherModel m;
    private int external=0;
    
    public LauncherController(LauncherModel lM, LauncherView lV) {
        this.m = lM;
        this.v = lV;    
        
        v.fillCmbSchema(m.getSchemaList());
        
        /* Set button handlers */
        v.setBtnCloseHandler(new EventHandler() {
            @Override
            public void handle(Event event) {
                v.closeWindow();
            }
        });
        
        v.setTfClickHandler(new EventHandler() {
            @Override
            public void handle(Event event) {
                FileChooser fc = new FileChooser();
                fc.setTitle("Select your Core Schema File");
                Stage stage = new Stage();
                File file = fc.showOpenDialog(stage);
                if(file != null) {
                    v.setTfUri(file.getAbsolutePath());
                }
            }
        });
        
        v.setCmbClickHandler(new EventHandler() {
            @Override
            public void handle(Event event) {
                if(v.getCmbUri().equals("Load from file...")) {
                    FileChooser fc = new FileChooser();
                    fc.setTitle("Select a Source Schema File");
                    Stage stage = new Stage();
                    File file = fc.showOpenDialog(stage);
                    if(file!=null) {
                        external=1;
                        ObservableList<String> res = m.getSchemaList();
                        res.add(file.getAbsolutePath());
                        v.fillCmbSchema(res);
                        v.setCmbSelection(file.getAbsolutePath());
                    }
                }
            }
            
        });
        
        v.setBtnAnalyzeHandler(new EventHandler() {
            @Override
            public void handle(Event event) {
                try {
                    v.closeWindow();
                    String r = m.fix(v.getTfUri(), v.getCmbUri(), external);
                    ResultModel mR = new ResultModel();
                    ResultView vR = new ResultView();
                    ResultController cR = new ResultController(mR,vR);
                    vR.setResult(r);
                } catch (IOException ex) {
                   //
                }
            }
        });
        
    }

}
