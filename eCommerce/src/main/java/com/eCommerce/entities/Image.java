package com.eCommerce.entities;

import jakarta.persistence.*;
import lombok.*;

@Table(name="images")
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Image {

    @Column(name="id")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="image_url")
    private String image_url;

    @ManyToOne
    @JoinColumn(name="product_id")
    private Product product;
    
}
