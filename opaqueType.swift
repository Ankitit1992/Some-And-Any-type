import UIKit


// some(Opaque) and any keybowrd

protocol Fuel {
    associatedtype FuelType where FuelType == Self
    static func buyFuel() -> FuelType
}

protocol Vehicle {
    associatedtype FuelType: Fuel
    var name: String {get}
    func engineStart()
    func fuelGasTanK(_ fuelType: FuelType)
}

struct Car: Vehicle {
    let name: String
    
    func engineStart() {
        print("\(name) engine started")
    }
    
    func fuelGasTanK(_ fuelType: Gasoline) {
        print(fuelType.name)
    }
    
}


struct Bus: Vehicle {
    let name: String
    func engineStart() {
        print("\(name) engine started")
    }
    func fuelGasTanK(_ fuelType: Diesle) {
        print(fuelType.disel)
    }
}

struct Gasoline: Fuel {
    let name = "Gasoline"
    
    static func buyFuel() -> Gasoline {
        return Gasoline()
    }
}

struct Diesle: Fuel {
    let disel = "Disel"
    static func buyFuel() -> Diesle {
        return Diesle()
    }
}

func createSomeVehicel() -> some Vehicle {
    return Car(name: "Car")
}

func createAnyVehicle(isPublicTransport: Bool) -> any Vehicle {
    if isPublicTransport {
        return Bus(name: "Bus")
    } else {
        return Car(name: "Car")
    }
}

func vehicleStarte(vehicles: [any Vehicle]) {
    vehicles.forEach {$0.engineStart()}
}

func fillAllGasTank(with vehicles: [any Vehicle]) {
    for vehicle in vehicles {
        // Unbox any type(or existential type) to some concrete type
        // type casting make easy in swift 5.7
        fillGasTank(with: vehicle)
    }
}

func fillGasTank(with vehichle: some Vehicle) {
    let fuel = type(of: vehichle).FuelType.buyFuel()
    vehichle.fuelGasTanK(fuel)
}

// some is opaque type which provide one laye of abstarction to concrete type. which in specfic for one create type object.
var cars: some Vehicle = Bus(name: "Bus")
//cars = Car() this line will throw erron Cannot assign value of type 'Car' to type 'some Vehicle'
var bus: some Vehicle = Bus(name: "Bus")
//print(cars == bus)
// to opaque type we can not assign same type of object will throw error
//cars = bus Cannot assign value of type 'some Vehicle' (type of 'bus') to type 'some Vehicle' (type of 'cars')

// Any is just opposite to some it will take or return any concrete type which will confirm protocol.
var car: any Vehicle = Bus(name: "Bus")
car = Car(name: "Car")

var bus1: any Vehicle = Bus(name: "Bus")
// Any can keep any type of concrete object in existenial box so we cannot compare two object and will get error
//print(car == bus1) Binary operator '==' cannot be applied to two 'any Vehicle' operands

let car1 = createSomeVehicel()
let car2 = createSomeVehicel()
//let isPublicTransport = car1 == car2

let vehicles: [some Vehicle] = [Car(name: "Car"), Car(name: "Car"), Car(name: "Care")]// will work fine
//let vehicles1: [some Vehicle] = [Car(), Bus()] will throw error , (some always accept one specific concrete type) Conflicting arguments to generic parameter 'τ_0_0' ('Car' vs. 'Bus')

let vehicles2: [any Vehicle] = [Car(name: "Car1"), Bus(name: "Bus1"), Car(name: "Car2"), Car(name: "Care3"), Bus(name: "Bus3")] // will work fine

// Dynamic Dispatch(or run time polymorphism)
vehicleStarte(vehicles: vehicles2)
fillAllGasTank(with: vehicles2)
