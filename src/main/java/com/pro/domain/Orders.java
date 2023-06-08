package com.pro.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("orders")
public class Orders {
    @TableId(type = IdType.AUTO)
    private Integer orderId;
    private Long memberId;
    private String memberName;
    private Long fId;
    private String fName;
    private Integer statue;

    public Orders(Long memberId, String memberName, Long fId, String fName, Integer statue) {
        this.memberId = memberId;
        this.memberName = memberName;
        this.fId = fId;
        this.fName = fName;
        this.statue = statue;
    }

    public Orders(Integer orderId, Long memberId, String memberName, Long fId, String fName, Integer statue) {
        this.orderId = orderId;
        this.memberId = memberId;
        this.memberName = memberName;
        this.fId = fId;
        this.fName = fName;
        this.statue = statue;
    }

    public Orders() {
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public Long getfId() {
        return fId;
    }

    public void setfId(Long fId) {
        this.fId = fId;
    }

    public String getfName() {
        return fName;
    }

    public void setfName(String fName) {
        this.fName = fName;
    }

    public Integer getStatue() {
        return statue;
    }

    public void setStatue(Integer statue) {
        this.statue = statue;
    }
}
