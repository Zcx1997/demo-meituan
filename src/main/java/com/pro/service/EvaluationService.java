package com.pro.service;

import com.pro.domain.Evaluation;

import java.util.List;

public interface EvaluationService {
    public List<Evaluation> getEvaluationByFoodId(Long foodId);
}
