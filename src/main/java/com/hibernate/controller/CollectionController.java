package com.hibernate.controller;

import com.hibernate.entity.Collection;
import com.hibernate.entity.Post; // 🎯 Post Entity အတွက် Import တိုးထားပါသည်
import com.hibernate.service.CollectionService;
import com.hibernate.service.PostService;
import java.util.List;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/collections")
public class CollectionController {

    private final CollectionService collectionService;
    private final PostService postService;

    @GetMapping
    public String listCollections(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        model.addAttribute("collections", collectionService.getCollectionsByUserId(userId));
        return "user/collection/list";
    }

    @PostMapping("/new")
    public String createCollection(
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam(value = "isPublic", defaultValue = "false") Boolean isPublic,
            HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        collectionService.createCollection(name, description, isPublic, userId);
        return "redirect:/user/collections";
    }

    @PostMapping("/add-post")
    public String addPostToCollection(
            @RequestParam("collectionId") Integer collectionId,
            @RequestParam("postId") Integer postId,
            @RequestParam("slug") String slug, 
            HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        collectionService.addPostToCollection(collectionId, postId);
        return "redirect:/posts/" + slug; 
    }

    @GetMapping("/delete/{id}")
    public String deleteCollection(@PathVariable Integer id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        collectionService.deleteCollection(id);
        return "redirect:/user/collections";
    }

    // 🎯 🌟 ဖိုဒါကို ကလစ်နှိပ်လိုက်ရင် ၎င်းထဲရှိ Cheat Sheet များကို ဆွဲထုတ်ပေးမည့် မက်သတ်အသစ်
 // 🎯 🌟 ဖိုဒါကို ကလစ်နှိပ်လိုက်ရင် ၎င်းထဲရှိ Cheat Sheet များကို ဆွဲထုတ်ပေးမည့် မက်သတ်
    @GetMapping("/{id}")
    public String viewCollectionItems(@PathVariable("id") Integer id, Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        Collection folder = collectionService.getCollectionById(id).orElse(null);
        model.addAttribute("folder", folder);
        List<Post> savedPosts = collectionService.getPostsByCollectionId(id);
        model.addAttribute("savedPosts", savedPosts);

        return "user/collection/view-items";
    }
    @GetMapping("/{collectionId}/remove-post/{postId}")
    public String removePostFromCollection(
            @PathVariable("collectionId") Integer collectionId,
            @PathVariable("postId") Integer postId,
            HttpSession session) {
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        collectionService.removePostFromCollection(collectionId, postId);
        return "redirect:/user/collections/" + collectionId;
    }
 // 🎯 🌟 ၇။ Folder အချက်အလက် (Name, Description, Public/Private) ကို ပြင်ဆင်ပေးမည့် မက်သတ်အသစ်
    @PostMapping("/edit")
    public String editCollection(
            @RequestParam("id") Integer id,
            @RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam(value = "isPublic", defaultValue = "false") Boolean isPublic,
            HttpSession session) {
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Service Layer ကို လှမ်းခေါ်ပြီး အချက်အလက်များကို Update လုပ်ခြင်း
        collectionService.updateCollection(id, name, description, isPublic);
        
        return "redirect:/user/collections";
    }
}