package com.pro.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("evaluation_member")
public class EvaluationMember{
    @TableId(type = IdType.AUTO)
    private long emId;
    private Long evaluationId;
    private Long memberId;
    private int state;


    public long getEmId() {
        return emId;
    }

    public void setEmId(long emId) {
        this.emId = emId;
    }

    public Long getEvaluationId() {
        return evaluationId;
    }

    public void setEvaluationId(Long evaluationId) {
        this.evaluationId = evaluationId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }
}
