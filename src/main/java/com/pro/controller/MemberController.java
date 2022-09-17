package com.pro.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.pro.dao.EvaluationMapper;
import com.pro.dao.EvaluationMemberMapper;
import com.pro.dao.FoodMapper;
import com.pro.dao.QiandaoMapper;
import com.pro.domain.*;
import com.pro.service.MemberService;
import com.pro.service.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class MemberController {

    @Autowired
    private MemberService memberService;
    @GetMapping("/login")
    public ModelAndView login(){
        return new ModelAndView("/login");
    }
    @Autowired
    private EvaluationMemberMapper evaluationMemberMapper;
    @Autowired
    private EvaluationMapper evaluationMapper;
    @Autowired
    private QiandaoMapper qiandaoMapper;
    @GetMapping("/register")
    public ModelAndView genRegister(){
        return new ModelAndView("/reg");
    }
    @PostMapping("/checkLogin")
    @ResponseBody
    public Map checkLogin(String username, String password, String vc, HttpSession session){
        String verifyCode = (String) session.getAttribute("verifyCode");
        Map result=new HashMap();
        if (vc==null||verifyCode==null||!vc.equalsIgnoreCase(verifyCode)){
            result.put("code","vc01"); //这个码，团队小组有文档标识是什么意思。
            result.put("msg","验证码错误");
        }else {
            try {
                Member member = memberService.checkLogin(username, password);
                if (member!=null){
                    session.setAttribute("loginMember",member);
                    result.put("code","0");
                    result.put("msg","success");
                    result.put("member",member);
                }
            } catch (ServiceException e) {
                e.printStackTrace();
                result.put("code",e.getCode());
                result.put("msg",e.getMsg());
            }
        }
        return result;
    }


    @PostMapping("/updateReadState")
    @ResponseBody
    public Map updateReadState(Long foodId,Long memberId,Integer readState){
        Map result=new HashMap();
        try {
            memberService.updateMemberReadState(foodId,memberId,readState);
            result.put("code","0");
            result.put("msg","success");
        } catch (ServiceException e) {
            e.printStackTrace();
            result.put("code",e.getCode());
            result.put("msg",e.getMsg());
        }
        return result;
    }

    @PostMapping("/selectpiao")
    @ResponseBody
    public Map selectpiao(Long memberId){
        Map result=new HashMap();
        try {
            Member member = memberService.selecMember(memberId);
            result.put("code","0");
            result.put("member",member);
        } catch (ServiceException e) {
            e.printStackTrace();
            result.put("code",e.getCode());
            result.put("msg",e.getMsg());
        }
        return result;
    }
    @PostMapping("/qiandao")
    @ResponseBody
    public Map qiandao(Long memberId){
        Map result=new HashMap();
        try {
            Date date = new Date();
            SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
            String time = format.format(date);
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("member_id",memberId);
            queryWrapper.eq("time",time);
            Qiandao qiandao = qiandaoMapper.selectOne(queryWrapper);
            if (qiandao==null){
                Qiandao qd = new Qiandao();
                qd.setTime(time);
                qd.setMemberId(memberId);
                qiandaoMapper.insert(qd);
                Member member = memberService.selecMember(memberId);
                member.setPiao(member.getPiao()+5);
                memberService.updatePiao(member);
                result.put("code","0");
                result.put("msg","签到成功");
            }else if (qiandao!=null){
                result.put("code","0");
                result.put("msg","今日已经签到");
            }
        } catch (ServiceException e) {
            e.printStackTrace();
            result.put("code",e.getCode());
            result.put("msg",e.getMsg());
        }
        return result;
    }

    @PostMapping("/evaluate")
    @ResponseBody
    public Map evaluate(Long memberId,Long foodId,Integer score,String content){
        Map result = new HashMap();
        try {
            Evaluation evaluate = memberService.evaluate(memberId, foodId, score, content);
            result.put("code","0");
            result.put("msg","success");
            result.put("data", evaluate);
        } catch (ServiceException e) {
            e.printStackTrace();
            result.put("code",e.getCode());
            result.put("msg",e.getMsg());
        }
        return result;
    }

    @PostMapping("/ifenjoy")
    @ResponseBody
    public Map ifenjoy(Long memberId){
        QueryWrapper queryWrapper = new QueryWrapper();
        queryWrapper.eq("member_id",memberId);
        Map result = new HashMap();
        try {
            List<EvaluationMember> list = evaluationMemberMapper.selectList(queryWrapper);
            result.put("code","0");
            result.put("msg","success");
            result.put("list", list);
        } catch (ServiceException e) {
            e.printStackTrace();
            result.put("code",e.getCode());
            result.put("msg",e.getMsg());
        }
        return result;
    }

    @PostMapping("/regist")
    @ResponseBody
    public Map regist(String vc, String username, String password, String nickname, HttpServletRequest request){
        String verifyCode = (String)request.getSession().getAttribute("verifyCode");
        Map result = new HashMap();
        if (vc==null||verifyCode==null||!vc.equalsIgnoreCase(verifyCode)){
            result.put("code","vc01"); //这个码，团队小组有文档标识是什么意思。
            result.put("msg","验证码错误");
        }else {
            try {
                Member member=memberService.createMember(username,password,nickname);
                result.put("code","0"); //这个码，团队小组有文档标识是什么意思。
                result.put("msg","success");
                result.put("data",member);  //如果前端需要，你就加上
            } catch (ServiceException e) {
                e.printStackTrace();
                result.put("code",e.getCode()); //这个码，团队小组有文档标识是什么意思。
                result.put("msg",e.getMsg());
                result.put("data",null);
            }
        }
        return result;
    }

    @PostMapping("/enjoy")
    @ResponseBody
    public Map enjoy(Long memberId,Long evaluationId){
        Map result = new HashMap();
        try {
            QueryWrapper queryWrapper = new QueryWrapper();
            queryWrapper.eq("member_id",memberId);
            queryWrapper.eq("evaluation_id",evaluationId);
            EvaluationMember evaluationMember = evaluationMemberMapper.selectOne(queryWrapper);
            if (evaluationMember!=null){
                if (evaluationMember.getState()==1){
                    evaluationMember.setState(0);
                    evaluationMemberMapper.updateById(evaluationMember);
                    evaluationMember=evaluationMemberMapper.selectOne(queryWrapper);
                    Evaluation evaluation = evaluationMapper.selectById(evaluationMember.getEvaluationId());
                    evaluation.setEnjoy(evaluation.getEnjoy()-1);
                    evaluationMapper.updateById(evaluation);
                    result.put("code","0");
                    result.put("msg","success");
                    result.put("evaluation",evaluation);
                    result.put("evalMem",evaluationMember);
                }else if (evaluationMember.getState()==0){
                    evaluationMember.setState(1);
                    evaluationMemberMapper.updateById(evaluationMember);
                    evaluationMember=evaluationMemberMapper.selectOne(queryWrapper);
                    Evaluation evaluation = evaluationMapper.selectById(evaluationMember.getEvaluationId());
                    evaluation.setEnjoy(evaluation.getEnjoy()+1);
                    evaluationMapper.updateById(evaluation);
                    result.put("code","0");
                    result.put("msg","success");
                    result.put("evaluation",evaluation);
                    result.put("evalMem",evaluationMember);
                }
            }else if (evaluationMember==null){
                EvaluationMember em = new EvaluationMember();
                em.setMemberId(memberId);
                em.setEvaluationId(evaluationId);
                em.setState(1);
                evaluationMemberMapper.insert(em);
                evaluationMember=evaluationMemberMapper.selectOne(queryWrapper);
                Evaluation evaluation = evaluationMapper.selectById(evaluationMember.getEvaluationId());
                evaluation.setEnjoy(evaluation.getEnjoy()+1);
                evaluationMapper.updateById(evaluation);
                result.put("code","0");
                result.put("msg","success");
                result.put("evaluation",evaluation);
                result.put("evalMem",evaluationMember);
            }
        } catch (ServiceException e) {
            e.printStackTrace();
            result.put("code",e.getCode());
            result.put("msg",e.getMsg());
        }

        return result;




    }
}



