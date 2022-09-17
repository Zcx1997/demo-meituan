package com.pro.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.pro.dao.CategoryMapper;
import com.pro.dao.FoodMapper;
import com.pro.domain.Food;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.awt.print.Book;

@Service
public class FoodServiceImpl implements FoodService {
    @Autowired
    private CategoryMapper categoryMapper;
    @Autowired
    private FoodMapper foodMapper;
    @Override
    public IPage<Food> paging(Long categoryId, String order,int page, int rows) {
        Page<Food> p = new Page<Food>(page,rows);
        QueryWrapper<Food> queryWrapper = new QueryWrapper<Food>();
        if (categoryId!=null&&categoryId!=-1){
            queryWrapper.eq("category_id",categoryId);

        }

        if (order!=null){
            if (order.equals("quantity")){
                queryWrapper.orderByDesc("quantity");
            }else if (order.equals("score")){
                queryWrapper.orderByDesc("score");
            }else if (order.equals("deleteNo")){
                queryWrapper.gt("quantity",0);
            }
        }
        Page<Food> pageObject = foodMapper.selectPage(p, queryWrapper);
        return pageObject;
    }

    @Override
    public Food selectById(Long foodId) {
        Food food = foodMapper.selectById(foodId);
        return food;
    }

    @Transactional
    public void updateEvaluation() {
        foodMapper.updateEvaluation();
    }

    @Override
    public void updateFood(Food food) {
        foodMapper.updateById(food);
    }
}
