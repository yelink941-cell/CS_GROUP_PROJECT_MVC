package com.hibernate.repository;

import com.hibernate.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {
    // ဒီနေရာမှာ ဘာမှ ထပ်ရေးစရာမလိုပါဘူး
    // JpaRepository က save(), findById(), findAll() စတဲ့ method တွေကို သူ့အလိုလို ရပြီးသားပါ
}