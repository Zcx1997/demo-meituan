package com.pro.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.pro.domain.Food;

import java.util.List;


public interface FoodMapper extends BaseMapper<Food> {
    void updateEvaluation();
    List shoucangList(int memberId);
}
