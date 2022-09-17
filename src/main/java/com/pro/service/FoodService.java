package com.pro.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.pro.domain.Food;

import java.util.List;

public interface FoodService {
    IPage<Food> paging(Long categoryId,String order,int page,int rows);
    public Food selectById(Long foodId);
    public void updateEvaluation();
    public void updateFood(Food food);
}
