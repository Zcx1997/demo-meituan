package com.pro.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.pro.domain.Food;


public interface FoodMapper extends BaseMapper<Food> {
    void updateEvaluation();
}
