package com.pro.task;

import com.pro.service.FoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class CompuTask {
    @Autowired
    private FoodService foodService;

    //任务调度
    @Scheduled(cron = "0 * * * * ?")
    public void updateEvaluation(){
        foodService.updateEvaluation();
        System.out.println("gengxing");
    }
}
