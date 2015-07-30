//
//  Genetic Algorithm.swift
//  ATLAS
//
//  Created by Martin Mumford on 5/1/15.
//  Copyright (c) 2015 Brigham Young University. All rights reserved.
//

import Foundation

protocol GeneticItem {
    var hashValue:Int { get }
    
    init(random:Bool)
    
    func mutate()
    func crossover(otherItem:GeneticItem)
    
    // 1.0 is perfection, 0.0 is absolute failure
    func fitness() -> Double
}

struct CrossoverPair: Hashable {
    var individualA:GeneticItem
    var individualB:GeneticItem
    
    var hashValue: Int {
        return "\(individualA.hashValue),\(individualB.hashValue)".hashValue
    }
}

func ==(lhs: CrossoverPair, rhs: CrossoverPair) -> Bool {
    return true
}

class GeneticAlgorithm<T:GeneticItem> {
    var population:[T]
    
    init()
    {
        population = [T]()
    }
    
    func initialize(popCount:Int)
    {
        for _ in 0..<popCount
        {
            population.append(T(random:true))
        }
    }
    
    // 0.0 mutates none of the population
    // 1.0 mutates all of the population
    func mutate(proportion:Double)
    {
        if (proportion >= 0.0 && proportion <= 1.0)
        {
            // Randomly select <proportion> individuals from the population
            let numberOfIndividualsToMutate = Int(floor(proportion*Double(population.count)))
            var indexesToMutate = Set<Int>()
            
            while indexesToMutate.count < numberOfIndividualsToMutate
            {
                // Randomly select an individual's index from the population
                let index = randIntBetween(0, population.count-1)
                indexesToMutate.insert(index)
            }
            
            // Mutate each of them
            for index in indexesToMutate
            {
                population[index].mutate()
            }
        }
    }
    
    // 0.0 performs crossover on none of the population
    // 1.0 performs crossover on all of the population
    func crossover(proportion:Double)
    {
        if (proportion >= 0.0 && proportion <= 1.0)
        {
            // Population Index List
            var individualIndexList = [Int]()
            for individualIndex in 0..<population.count
            {
                individualIndexList.append(individualIndex)
            }
            
            let numberOfPairsToCrossover = Int(floor((proportion/2.0)*Double(population.count)))
            
            var pairsToCrossover = Set<(i1:T,i2:T)>()
            for _ in numberOfPairsToCrossover
            
        }
    }
    
    func fittestIndividual() -> T?
    {
        var highestFitness = 0.0
        var fittestIndividual:T
        
        for individual in population
        {
            let fitness = individual.fitness()
            
            if (fitness > highestFitness)
            {
                highestFitness = fitness
                fittestIndividual = individual
            }
        }
        
        return fittestIndividual
    }
}