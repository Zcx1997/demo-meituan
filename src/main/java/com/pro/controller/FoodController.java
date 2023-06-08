package com.pro.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.pro.dao.EvaluationMemberMapper;
import com.pro.dao.FoodMapper;
import com.pro.dao.OrderMapper;
import com.pro.domain.*;
import com.pro.service.CategoryService;
import com.pro.service.EvaluationService;
import com.pro.service.FoodService;
import com.pro.service.MemberService;
import com.pro.service.exception.ServiceException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
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

    @Autowired
    private FoodMapper foodMapper;


    @Autowired
    private OrderMapper orderMapper;

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

    @PostMapping("/yuyueList")
    public List yuyueList(int memberId){
        QueryWrapper queryWrapper = new QueryWrapper();
        queryWrapper.eq("member_id",memberId);
        List list = orderMapper.selectList(queryWrapper);
        return list;
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

    @PostMapping("/shoucangList")
    public List shoucangList(int memberId){
        List list = foodMapper.shoucangList(memberId);
        return list;
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
                QueryWrapper queryWrapper = new QueryWrapper();
                queryWrapper.eq("member_id",memberId);
                queryWrapper.eq("f_id",foodId);
                queryWrapper.eq("statue",0);
                Orders orders1 = orderMapper.selectOne(queryWrapper);
                if (orders1!=null){
                    result.put("code","405");
                    result.put("msg","已经购买过");
                    return result;

                }
                QueryWrapper queryWrapper1 = new QueryWrapper();
                queryWrapper1.eq("member_id",memberId);
                List<Orders> list1 = orderMapper.selectList(queryWrapper1);
                member.setPiao(member.getPiao()-1);
                memberService.updatePiao(member);
                member = memberService.selecMember(memberId);
                Food food = foodService.selectById(foodId);
                food.setNum(food.getNum()-1);
                foodService.updateFood(food);
                food = foodService.selectById(foodId);
                Orders orders = new Orders(memberId,member.getUsername(),foodId,food.getFoodName(),0);
                orderMapper.insert(orders);
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
