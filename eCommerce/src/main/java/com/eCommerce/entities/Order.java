package com.eCommerce.entities;

import jakarta.persistence.*;
import lombok.*;

@Table(name="orders")
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    @Column(name="id")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="total")
    private double total;

    @ManyToOne
    @JoinColumn(name="user_id")
    private User user;
    
}
