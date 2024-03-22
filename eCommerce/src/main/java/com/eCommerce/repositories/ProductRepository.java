package com.eCommerce.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.eCommerce.entities.Product;

public interface ProductRepository extends JpaRepository <Product, Integer> {

}
