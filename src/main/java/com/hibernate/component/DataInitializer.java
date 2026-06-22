package com.hibernate.component;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import com.hibernate.entity.Category;
import com.hibernate.entity.Post;
import com.hibernate.entity.User;
import com.hibernate.repository.*;

@Component
public class DataInitializer implements ApplicationListener<ContextRefreshedEvent> {

    @Autowired private UserRepository userRepository;
    @Autowired private CategoryRepository categoryRepository;
    @Autowired private PostRepository postRepository;

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        // Data စစ်ဆေးပြီးမှ ထည့်ရန် (Duplicate မဖြစ်အောင်)
        if (userRepository.count() == 0) {
            User user = new User();
            user.setUsername("Mg Mg");
            user.setEmail("mgmg@gmail.com");
            user.setPasswordHash("123456"); 
            userRepository.save(user);

            Category cat = new Category();
            cat.setName("General");
            categoryRepository.save(cat);

            Post post = new Post();
            post.setTitle("Default Discussion");
            post.setSlug("default-post");
            post.setAuthor(user);
            post.setCategory(cat);
            postRepository.save(post);
        }
    }
}