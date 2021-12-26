#Машина
class Car {
    #Брэнд
    [string]$Brand
    #Модель
    [string]$Model
    #Количество дверей
    [int]$DoorCount
    #Расход топлива
    [float]$FuelConsumption
    #Текущее количество бензина
    [float]$FuelQuantity
    Car(){}
    #Конструктор
    Car([string]$brand, [string]$model, [int]$doorCount, [float]$fuelConsumption, [float]$fuelQuantity)
    {
        $this.Brand = $brand
        $this.Model = $model
        $this.DoorCount = $doorCount
        $this.FuelConsumption = $fuelConsumption
        $this.FuelQuantity = $fuelQuantity
    }
    #Информация о машине
    [string]CarInfo()
    {
        return ("{0}|{1}|{2}|{3}|{4}" -f $this.Brand, $this.Model, $this.doorCount, $this.FuelConsumption, $this.FuelQuantity)
    }
    #количество километров, которые еще можно проехать
    [string]KilometersCountDrive()
    {
        return ("Количество часов, которые еще можно проехать: {0}" -f $this.KilometersCountDriveCalc())
    }
    #количество часов, которые еще можно проехать
    [string]HoursCountDrive([int]$speed)
    {
        return ("Количество часов, которые еще можно проехать: {0}" -f $this.HoursCountDriveCalc($speed))
    }
    
    #Подсчет количества километров, которые еще можно проехать
    hidden [float]KilometersCountDriveCalc()
    {
        $kilimCount = $this.FuelQuantity/$this.FuelConsumption*100
        return $kilimCount
    }
    
    #Подсчет количества часов, которые еще можно проехать
    hidden [float]HoursCountDriveCalc([int]$speed)
    {
        $HourCount = $this.KilometersCountDriveCalc()/$speed
        return $HourCount
    }
    #Сериализация в JSON
    [void] SerializeToJson()
    {
        $body = @{
        "Brand"= $this.Brand
        "Model"= $this.Model
        "DoorCount"=$this.DoorCount
        "FuelConsumption"=$this.FuelConsumption
        "FuelQuantity"=$this.FuelQuantity
        } | ConvertTo-Json 
        Invoke-WebRequest -Uri http://localhost/ -Body $body -ContentType "application/json" -Method 'POST'
    }
    #Десериализация из JSON
    [void] DeserializeFromJson([string]$json)
    {
        $obj = ConvertFrom-Json -InputObject $json
        if ( $obj.Brand -ne $null )
        {
            $this.Brand = $obj.Brand
        }
        if ( $obj.Model -ne $null )
        {
            $this.Model = $obj.Model
        }
        if ( $obj.DoorCount -ne $null )
        {
            $this.DoorCount = $obj.DoorCount
        }
        if ( $obj.FuelConsumption -ne $null )
        {
            $this.FuelConsumption = $obj.FuelConsumption
        }
        if ( $obj.FuelQuantity -ne $null )
        {
            $this.FuelQuantity = $obj.FuelQuantity
        }
    }
}
#Двухдверная машина
class Coupe : Car
{
    #Конструктор
     Coupe([string]$brand, [string]$model, [float]$fuelConsumption, [float]$fuelQuantity)
        {
            $this.Brand = $brand
            $this.Model = $model
            $this.DoorCount = 2
            $this.FuelConsumption = $fuelConsumption
            $this.FuelQuantity = $fuelQuantity
        }
}

$coupeCar = [Coupe]::new("Nissan", "Skyline", 10, 57)
$coupeCar.CarInfo() 
$coupeCar.KilometersCountDrive() 
$coupeCar.HoursCountDrive(120) 
$coupeCar.SerializeToJson()

$mainCar = [Car]::new("Toyota", "Land Cruser", 5, 8, 43)
$mainCar.CarInfo() 
$mainCar.KilometersCountDrive() 
$mainCar.HoursCountDrive(80) 
$mainCar


$json = @"
{
    "Brand":  "Nissan",
    "FuelQuantity":  57,
    "DoorCount":  4,
    "Model":  "March",
    "FuelConsumption":  10
}
"@

$car3 = [Car]::new()
$car3.CarInfo()
$car3.DeserializeFromJson($json)
$car3
