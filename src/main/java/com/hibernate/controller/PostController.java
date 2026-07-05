package com.hibernate.controller;

import com.hibernate.entity.Post;
import com.hibernate.entity.enums.ContentType;
import com.hibernate.entity.enums.PostVisibility;
import com.hibernate.service.BookmarkService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.CollectionService; 
import com.hibernate.service.CommentService;
import com.hibernate.service.PostContentService;
import com.hibernate.service.PostFileService;
import com.hibernate.service.PostLikeService;
import com.hibernate.service.PostService;
import com.hibernate.service.TagService;
import com.hibernate.service.UserService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user/posts")
public class PostController {
    private final PostService postService;
    private final CategoryService categoryService;
    private final TagService tagService;
    private final CollectionService collectionService; 

    
    private final PostContentService postContentService;
    private final PostFileService postFileService;
    private final PostLikeService postLikeService; 
    private final CommentService commentService;
    private final BookmarkService bookmarkService;
    private final UserService userService;
    @GetMapping
    public String listPosts(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        model.addAttribute("posts", postService.getPostsByAuthorId(userId));
        return "user/post/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model, HttpSession session) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }

        model.addAttribute("post", new Post());
        loadFormData(model);
        return "user/post/form";
    }

    @PostMapping
    public String createPost(
            @RequestParam String title,
            @RequestParam String slug,
            @RequestParam(required = false) String excerpt,
            @RequestParam Integer categoryId,
            @RequestParam(required = false) List<Integer> tagIds,
            @RequestParam PostVisibility visibility,
            @RequestParam(value = "sectionSubtitles[]", required = false) List<String> sectionSubtitles,
            @RequestParam(value = "contentTypes[]", required = false) List<ContentType> contentTypes,
            @RequestParam(value = "contentDataList[]", required = false) List<String> contentDataList,
            @RequestParam(value = "sortOrders[]", required = false) List<Integer> sortOrders,
            Model model,
            HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        Post post = buildPost(title, slug, excerpt, visibility);

        if (postService.existsBySlug(slug)) {
            model.addAttribute("errorMessage", "Post slug already exists.");
            model.addAttribute("post", post);
            model.addAttribute("selectedCategoryId", categoryId);
            model.addAttribute("selectedTagIds", tagIds);
            preserveSectionData(
                    model,
                    sectionSubtitles,
                    contentTypes,
                    contentDataList,
                    sortOrders);
            loadFormData(model);
            return "user/post/form";
        }

        try {
            postService.createPost(
                    post,
                    categoryId,
                    tagIds,
                    userId,
                    visibility,
                    sectionSubtitles,
                    contentTypes,
                    contentDataList,
                    sortOrders);
            return "redirect:/user/posts";
        } catch (IllegalArgumentException exception) {
            post.setId(null);
            model.addAttribute("errorMessage", exception.getMessage());
            model.addAttribute("post", post);
            model.addAttribute("selectedCategoryId", categoryId);
            model.addAttribute("selectedTagIds", tagIds);
            preserveSectionData(
                    model,
                    sectionSubtitles,
                    contentTypes,
                    contentDataList,
                    sortOrders);
            loadFormData(model);
            return "user/post/form";
        }
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        return postService.getPostById(id)
                .filter(post -> post.getAuthor().getId().equals(userId))
                .map(post -> {
                    model.addAttribute("post", post);
                    loadFormData(model);
                    return "user/post/form";
                })
                .orElse("redirect:/user/posts");
    }

    @PostMapping("/update/{id}")
    public String updatePost(
            @PathVariable Integer id,
            @RequestParam String title,
            @RequestParam String slug,
            @RequestParam(required = false) String excerpt,
            @RequestParam Integer categoryId,
            @RequestParam(required = false) List<Integer> tagIds,
            @RequestParam PostVisibility visibility,
            HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        if (postService.getPostById(id)
                .filter(existingPost -> existingPost.getAuthor().getId().equals(userId))
                .isEmpty()) {
            return "redirect:/user/posts";
        }

        Post post = buildPost(title, slug, excerpt, visibility);
        postService.updatePost(id, post, categoryId, tagIds, visibility);
        return "redirect:/user/posts";
    }

    @GetMapping("/delete/{id}")
    public String deletePost(@PathVariable Integer id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        if (postService.getPostById(id)
                .filter(post -> post.getAuthor().getId().equals(userId))
                .isEmpty()) {
            return "redirect:/user/posts";
        }

        postService.deletePost(id);
        return "redirect:/user/posts";
    }

    @GetMapping("/{slug}")
    public String showPostDetail(@PathVariable String slug, Model model, HttpSession session) {
        return postService.getPostBySlug(slug).map(post -> {
            model.addAttribute("post", post);
            model.addAttribute("contents", post.getContents());
            
            Long userId = (Long) session.getAttribute("userId");
            
            // 🎯 FIX: Default follow status to false
            boolean isFollowingCreator = false; 
            
            if (userId != null) {
                if (post.getAuthor() != null) {
                    // Calculate the real-time status straight from your database
                    isFollowingCreator = userService.isFollowing(userId, post.getAuthor().getId());
                }
                
                boolean hasLiked = postLikeService.hasUserLiked(post.getId(), userId);
                model.addAttribute("hasUserLiked", hasLiked);
                
                boolean hasBookmarked = bookmarkService.hasUserBookmarked(userId, post.getId());
                model.addAttribute("hasUserBookmarked", hasBookmarked);
                
                model.addAttribute("collections", collectionService.getCollectionsByUserId(userId));
                
                
                // 🟢 ဤနေရာတွင် ထည့်ပေးရန် - JSP ဘက်က Not Empty userLoggedIn ဟု စစ်ထားသည်နှင့် တိုက်ဆိုင်စေသည်
                model.addAttribute("userLoggedIn", userId); 
            }
            
            // 🎯 FIX: Explicitly bind the real-time boolean flag to the view model context
            model.addAttribute("isFollowing", isFollowingCreator);
            
            model.addAttribute("likeCount", postLikeService.getLikeCount(post.getId()));
            model.addAttribute("totalBookmarks", bookmarkService.getBookmarkCount(post.getId()));
            model.addAttribute("comments", commentService.getActiveParentComments(post.getId()));
            
            return "public/post/details"; 
        }).orElse("redirect:/user/posts");
    }

    private boolean isLoggedIn(HttpSession session) {
        return session.getAttribute("userId") != null;
    }

    private Post buildPost(String title, String slug, String excerpt, PostVisibility visibility) {
        Post post = new Post();
        post.setTitle(title);
        post.setSlug(slug);
        post.setExcerpt(excerpt);
        post.setVisibility(visibility);
        return post;
    }

    private void loadFormData(Model model) {
        model.addAttribute("categories", categoryService.getAllCategories());
        model.addAttribute("tags", tagService.getAllTags());
        model.addAttribute("visibilities", PostVisibility.values());
        model.addAttribute(
                "sectionTypes",
                new ContentType[] {
                    ContentType.TEXT,
                    ContentType.CODE,
                    ContentType.IMAGE,
                    ContentType.TABLE
                });
    }

    private void preserveSectionData(
            Model model,
            List<String> sectionSubtitles,
            List<ContentType> contentTypes,
            List<String> contentDataList,
            List<Integer> sortOrders) {
        model.addAttribute("sectionSubtitles", sectionSubtitles);
        model.addAttribute("selectedContentTypes", contentTypes);
        model.addAttribute("contentDataList", contentDataList);
        model.addAttribute("sortOrders", sortOrders);
    }
    
    @PostMapping("/like")
    public ResponseEntity<Map<String, Object>> addLike(@RequestParam("postId") Integer postId, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");

        Map<String, Object> response = new HashMap<>();
        
        // 🟢 User က Login မဝင်ထားရင် (သို့) Session ပြတ်တောက်သွားရင် 401 ပြန်ပို့မည်
        if (userId == null) {
            response.put("status", "unauthorized");
            response.put("message", "Login ဝင်ရန် လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        
        boolean isLikedNow = postLikeService.toggleLike(postId, userId);
        long totalLikes = postLikeService.getLikeCount(postId);
        
        response.put("status", "success");
        response.put("isLiked", isLikedNow);
        response.put("totalLikes", totalLikes);
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/comment/add")
    public ResponseEntity<Map<String, Object>> addComment(
            @RequestParam("postId") Integer postId, 
            @RequestParam("commentText") String text, 
            HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        
        Map<String, Object> response = new HashMap<>();
        
        // 🟢 User က Login မဝင်ထားရင် (သို့) Session ပြတ်တောက်သွားရင် 401 ပြန်ပို့မည်
        if (userId == null) {
            response.put("status", "unauthorized");
            response.put("message", "Login ဝင်ရန် လိုအပ်ပါသည်။");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        
        postService.addComment(postId, userId, text);
        response.put("status", "success");
        response.put("totalComments", commentService.getTotalActiveComments(postId));
        return ResponseEntity.ok(response);
    }

    
    @GetMapping("/details/{id}")
    public String getPostDetails(@PathVariable("id") Integer id, Model model, HttpSession session) {
        Post post = postService.getPostById(id).orElseThrow(() -> new IllegalArgumentException("Post not found"));
        model.addAttribute("post", post);
        model.addAttribute("contents", postContentService.getContentsByPostId(id));
        model.addAttribute("postFiles", postFileService.getFilesByPostId(id));

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        if (userId != null) {
        	boolean hasLiked = postLikeService.hasUserLiked(id, userId); // DB ကနေ စစ်မယ်
        	model.addAttribute("hasUserLiked", hasLiked);
            
            boolean hasBookmarked = bookmarkService.hasUserBookmarked(userId, id);
            model.addAttribute("hasUserBookmarked", hasBookmarked);
            
            // 🟢 JSTL မှ not empty userLoggedIn ဖြင့် စစ်ဆေးနိုင်ရန် သေချာထည့်ပေးခြင်း
            model.addAttribute("userLoggedIn", userId); 
        }
        
        model.addAttribute("likeCount", postLikeService.getLikeCount(id));
        model.addAttribute("comments", commentService.getActiveParentComments(id));
        model.addAttribute("totalComments", commentService.getTotalActiveComments(id));
        
        model.addAttribute("totalBookmarks", bookmarkService.getBookmarkCount(id));
        
        return "public/post/details"; 
    }
    @GetMapping("/bookmark")
    public String showMyBookmarks(Model model, HttpSession session) {
      Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

    	
        // Bookmarked လုပ်ထားသော Post စာရင်းများကို ထည့်ပေးခြင်း
        model.addAttribute("posts", bookmarkService.getBookmarksByUserId(userId));
        
        // Tab အခြေအနေကို သတ်မှတ်ပေးခြင်း (Navbar သို့မဟုတ် sidebar တွင် Active ဖြစ်နေစေရန်)
        model.addAttribute("activeTab", "bookmarks");
        
        // 🟢 သီးသန့်ဖိုင်အသစ်မသုံးတော့ဘဲ My Posts စာရင်းပြ JSP ဖိုင်ကို ပြန်သုံးခြင်း
        return "user/post/list"; 
    }
    
}