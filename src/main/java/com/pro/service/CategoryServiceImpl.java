package com.pro.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.pro.dao.CategoryMapper;
import com.pro.domain.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
@Service
@Transactional(propagation = Propagation.NOT_SUPPORTED,readOnly = true)//不需要事务管理，只查询
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;
    @Override
    public List<Category> selectAll() {
        List<Category> categoryList = categoryMapper.selectList(new QueryWrapper<Category>());
        return categoryList;
    }
}
