package com.pro.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.pro.dao.EvaluationMapper;
import com.pro.dao.FoodMapper;
import com.pro.dao.MemberMapper;
import com.pro.domain.Evaluation;
import com.pro.domain.Food;
import com.pro.domain.Member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class EvaluationServiceImpl implements EvaluationService {
    @Autowired
    private EvaluationMapper evaluationMapper;
    @Autowired
    private FoodMapper foodMapper;
    @Autowired
    private MemberMapper memberMapper;
    @Override
    public List<Evaluation> getEvaluationByFoodId(Long foodId) {
        QueryWrapper queryWrapper = new QueryWrapper();
        queryWrapper.eq("food_id",foodId);
        queryWrapper.orderByDesc("create_time");
        List<Evaluation> evaluationList = evaluationMapper.selectList(queryWrapper);
        Food food = foodMapper.selectById(foodId);
        for (Evaluation evaluation  : evaluationList) {
            Member member = memberMapper.selectById(evaluation.getMemberId());
            evaluation.setMember(member);
            evaluation.setFood(food);
        }
        return evaluationList;
    }
}
