package com.pro.service;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.pro.domain.Evaluation;
import com.pro.domain.Member;
import com.pro.domain.MemberReadState;

public interface MemberService {
    public Member checkLogin(String username,String password);
    public MemberReadState updateMemberReadState(Long foodId, Long memberId, Integer readState);
    public MemberReadState selectMemberReadState(Long memberId,Long bookId);
    public Evaluation evaluate(Long memberId, Long bookId, Integer score, String content);
    public Member createMember(String username, String password, String nickname);
    public void updatePiao(Member member);
    public Member selecMember(Long memberId);
}
