package com.eCommerce.entities;

import jakarta.persistence.*;
import lombok.*;

@Table(name="carts")
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Cart {

    @Column(name="id")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="total")
    private double total;

    @OneToOne
    @JoinColumn(name="user_id")
    private User user;

}
