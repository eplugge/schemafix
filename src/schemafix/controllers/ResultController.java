/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package schemafix.controllers;

import javafx.event.Event;
import javafx.event.EventHandler;
import schemafix.models.LauncherModel;
import schemafix.models.ResultModel;
import schemafix.views.LauncherView;
import schemafix.views.ResultView;

/**
 *
 * @author eelco
 */
public class ResultController {
    private ResultView v;
    private ResultModel m;
    
    public ResultController(ResultModel rM, ResultView rV) {
        this.m = rM;
        this.v = rV;
        
    /* The "Save"-button will launch a new instance of the Launch window */
    v.setBtnCloseHandler(new EventHandler() {
        @Override
        public void handle(Event event) {
            v.closeWindow();                
            LauncherModel m = new LauncherModel();
            LauncherView v = new LauncherView();
            LauncherController c = new LauncherController(m,v);                 
        }
    });        
        
    }


    
}
