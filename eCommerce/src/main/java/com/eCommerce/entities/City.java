package com.eCommerce.entities;

import java.util.*;

import jakarta.persistence.*;
import lombok.*;

@Table(name="cities")
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class City {

    @Column(name="id")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name="name")
    private String name;

    @ManyToOne
    @JoinColumn(name="country_id")
    private Country country;

    @OneToMany(mappedBy = "city")
    private List<Address> addresses;
    
}
