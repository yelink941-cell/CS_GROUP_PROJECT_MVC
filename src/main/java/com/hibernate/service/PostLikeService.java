package com.hibernate.service;

public interface PostLikeService {
    // Like ရှိလျှင် unlike လုပ်၊ မရှိလျှင် like ထည့်သည့် လုပ်ဆောင်ချက်
    // Return: true = like ပေးလိုက်, false = unlike လုပ်လိုက်
    boolean toggleLike(Integer postId, Long userId);

    // Post တစ်ခု၏ စုစုပေါင်း Like အရေအတွက်ကို ရယူရန်
    long getLikeCount(Integer postId);

    // လက်ရှိ User က အဆိုပါ Post ကို Like ပေးထားပြီးလား စစ်ဆေးရန်
    boolean hasUserLiked(Integer postId, Long userId);
}
