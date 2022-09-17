package com.pro.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.pro.dao.EvaluationMapper;
import com.pro.dao.MemberMapper;
import com.pro.dao.MemberReadStateMapper;
import com.pro.domain.Evaluation;
import com.pro.domain.Member;
import com.pro.domain.MemberReadState;
import com.pro.service.exception.ServiceException;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Random;

@Service
public class MemberServiceImpl implements MemberService {
    @Autowired
    private MemberMapper memberMapper;
    @Autowired
    private MemberReadStateMapper memberReadStateMapper;
    @Autowired
    private EvaluationMapper evaluationMapper;

    public Member createMember(String username, String password, String nickname) {
        QueryWrapper queryWrapper = new QueryWrapper();
        queryWrapper.eq("username",username);

        List<Member> memberlist = memberMapper.selectList(queryWrapper);
        if (memberlist.size()>0){
            //如果大于0，说明这个用户已经有了，就不能再注册这个号了，要抛出异常
            throw new ServiceException("err01","用户名已存在");
        }

        Member member=new Member();
        member.setUsername(username);
        member.setNickname(nickname);

        //member.setPassword(password);  待加密
        Random random = new Random();
        int salt=random.nextInt(1000)+1000;
        String str=password+salt;
        String pwd = DigestUtils.md5Hex(str);
        member.setPassword(pwd);
        Date date = new Date();
        member.setCreateTime(date);
        member.setSalt(salt);
        memberMapper.insert(member);
        return member;
    }

    @Override
    public void updatePiao(Member member) {
        memberMapper.updateById(member);
    }

    @Override
    public Member selecMember(Long memberId) {
        Member member = memberMapper.selectById(memberId);
        return member;
    }

    @Override
    public Member checkLogin(String username, String password) {
        QueryWrapper<Member> queryWrapper = new QueryWrapper<Member>();
        queryWrapper.eq("username",username);

        Member member = memberMapper.selectOne(queryWrapper);
        if (member==null){
            throw new ServiceException("err02","用户不存在");  
        }
        String pwd = DigestUtils.md5Hex(password + member.getSalt());
        if (!pwd.equals(member.getPassword())){
            throw new ServiceException("err03","输入密码不对");
        }
        return member;
    }

    @Override
    public MemberReadState updateMemberReadState(Long foodId,Long memberId, Integer readState) {
        QueryWrapper<MemberReadState> queryWrapper=new QueryWrapper();
        queryWrapper.eq("food_id",foodId);
        queryWrapper.eq("member_id",memberId);

        MemberReadState memberReadState = memberReadStateMapper.selectOne(queryWrapper);
        //如果没查到表示你是第一次来
        if (memberReadState==null){
            memberReadState=new MemberReadState();
            memberReadState.setMemberId(memberId);
            memberReadState.setFoodId(foodId);
            memberReadState.setReadState(readState);
            memberReadState.setCreateTime(new Date());

            memberReadStateMapper.insert(memberReadState);
        }else{
            memberReadState.setReadState(readState);
            memberReadStateMapper.updateById(memberReadState);
        }
        return memberReadState;
    }

    @Transactional(propagation = Propagation.NOT_SUPPORTED,readOnly = true)
    public MemberReadState selectMemberReadState(Long memberId, Long foodId){
        QueryWrapper<MemberReadState> queryWrapper = new QueryWrapper();
        queryWrapper.eq("food_id",foodId);
        queryWrapper.eq("member_id",memberId);
        MemberReadState memberReadState = memberReadStateMapper.selectOne(queryWrapper);
        return memberReadState;
    }

    @Override
    public Evaluation evaluate(Long memberId, Long foodId, Integer score, String content) {
        Evaluation evaluation = new Evaluation();
        evaluation.setMemberId(memberId);
        evaluation.setFoodId(foodId);
        evaluation.setScore(score);
        evaluation.setContent(content);
        Date date = new Date();
        evaluation.setCreateTime(date);
        evaluation.setEnjoy(0);
        evaluationMapper.insert(evaluation);
        return evaluation;
    }



}
