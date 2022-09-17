package com.pro.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.pro.dao.EvaluationMemberMapper;
import com.pro.dao.FoodMapper;
import com.pro.domain.*;
import com.pro.service.CategoryService;
import com.pro.service.EvaluationService;
import com.pro.service.FoodService;
import com.pro.service.MemberService;
import com.pro.service.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class FoodController {
    @Autowired
    private CategoryService categoryService;

    @Autowired
    private FoodService foodService;

    @Autowired
    private EvaluationService evaluationService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private EvaluationMemberMapper evaluationMemberMapper;

    @GetMapping("/")
    public ModelAndView showIndex(){
        ModelAndView modelAndView = new ModelAndView("/index");
        List<Category> categoryList = categoryService.selectAll();
        modelAndView.addObject(categoryList);
        return modelAndView;
    }


    @GetMapping("/foods")
    @ResponseBody
    public IPage<Food> selectAllFood(Long categoryId,String order,Integer page){
        if (page==null){
            page=1;
        }
        IPage<Food> paging = foodService.paging(categoryId, order, page, 2);
        return paging;


    }

    @GetMapping("/food/{foodId}")
    public ModelAndView displayBookDetail(@PathVariable("foodId")Long foodId, HttpSession session){
        Food food = foodService.selectById(foodId);
        ModelAndView modelAndView = new ModelAndView("/detail");
        List<Evaluation> evaluationList = evaluationService.getEvaluationByFoodId(foodId);
        Member member = (Member) session.getAttribute("loginMember");
        QueryWrapper queryWrapper = new QueryWrapper();
        if (member!=null){
            MemberReadState memberReadState = memberService.selectMemberReadState(member.getMemberId(), foodId);
            modelAndView.addObject("memberReadState",memberReadState);
        }
        modelAndView.addObject("food",food);
        modelAndView.addObject("evaluationList",evaluationList);
        return modelAndView;

    }

    @PostMapping("/baoming")
    @ResponseBody
    public Map baoming(Long memberId,Long foodId){
        Map result = new HashMap();
        try {
            Member member = memberService.selecMember(memberId);
            if (member.getPiao()<1){
                result.put("code","1");
                result.put("msg","你的票不够");
            }else{
                member.setPiao(member.getPiao()-1);
                memberService.updatePiao(member);
                member = memberService.selecMember(memberId);
                Food food = foodService.selectById(foodId);
                food.setNum(food.getNum()-1);
                foodService.updateFood(food);
                food = foodService.selectById(foodId);
                result.put("code","0");
                result.put("msg","success");
                result.put("member", member);
                result.put("food",food);
            }

        } catch (ServiceException e) {
            e.printStackTrace();
            result.put("code",e.getCode());
            result.put("msg",e.getMsg());
        }
        return result;
    }

}
