package com.eCommerce.entities;

import java.util.*;

import jakarta.persistence.*;
import lombok.*;

@Table(name="countries")
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Country {

    @Column(name="id")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="name")
    private String name;

    @OneToMany(mappedBy = "country")
    private List<City> cities;

	
}
