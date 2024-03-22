package com.eCommerce.controllers;

import java.util.*;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.eCommerce.entities.Product;
import com.eCommerce.repositories.ProductRepository;

@RestController
@RequestMapping("/api/products")
public class ProductsController {

	private ProductRepository productRepository;
	
	public ProductsController(ProductRepository productRepository) {
		this.productRepository = productRepository;
	}
	
    @GetMapping
    public List<Product> getAll() {
        return productRepository.findAll();
    }

    @PostMapping
    public String add(@RequestBody Product product)
    {
        productRepository.save(product);
        return "Ürün başarıyla eklendi.";
    }

    @PutMapping
    public String update(@RequestBody Product product)
    {
        productRepository.save(product);
        return "Ürün başarıyla güncellendi";
    }

    @DeleteMapping
    public String delete(@RequestParam int id)
    {
        Product product = productRepository
                .findById(id)
                .orElseThrow(()-> new RuntimeException("Böyle bir ürün bulunamadı."));
        productRepository.delete(product);
        return "Ürün başarıyla silindi";
    }
    
}
