package com.eCommerce.entities;

import java.util.*;

import jakarta.persistence.*;
import lombok.*;

@Table(name="address")
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Address {

    @Column(name="id")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="address_line1")
    private String addressLine1;

    @Column(name="address_line2")
    private String addressLine2;

    @ManyToOne
    @JoinColumn(name="city_id")
    private City city;

    @Column(name="postal_code")
    private int postalCode;

    @ManyToMany
    @JoinTable(name="user_address",
            joinColumns = @JoinColumn(name="user_id", referencedColumnName="id"),
            inverseJoinColumns =
            @JoinColumn(name="address_id", referencedColumnName = "id"))
    private List<User> users;
    
}
