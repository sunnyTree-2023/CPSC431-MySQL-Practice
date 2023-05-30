<?php
error_reporting(E_ALL);

require("helpers/data_source.php");


$dbName = "cpsc431_hw2";

if(isset($_GET['db'])){
    $dbName = $_GET['db'];
}

$credentials = array(
    "host"=>"localhost:3306",
    "username"=>"root",
    "password" =>"",
    "schema" => $dbName
);

function runTest($query, $params, $testName)
{
    global $credentials;

    $Data = new DataSource($credentials);
    
    $result = array();

    try {

        $pdo = $Data->PDO();

        $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, 1);

        $statement = $pdo->prepare($query);

        $statement->execute($params);

        $testNumber = 1;

        //$result[$testName] = $statement->fetchAll();
        do {
            $res = $statement->fetchAll();

            if (count($res) > 0) {
                $result[$testName . "_" . $testNumber] = $res;
            }
            $testNumber++;
        } while ($statement->nextRowset());
    } catch (Exception $e) {
        $result[$testName] = $e->getMessage();
    }

    //print_r($result);

    return $result;
}


$queries = array(
    "GetAll" =>
    "SELECT  `first_name`, `last_name`, `last_visit` FROM pet_owner;
     SELECT  p.name, CONCAT(o.first_name, ' ', o.last_name) as parent, c.name as color, `species`
     FROM pet as p
     JOIN pet_owner as o
     JOIN color as c
     ON p.color_idx = c.idx and p.pet_owner_idx = o.idx;
     SELECT  `name` FROM color;",
    "create_pet" => "CALL create_pet(:name,:species,:owner_idx,:color_idx);",
    "read_pet" => "CALL read_pet(:idx);",
    "update_pet" => "CALL update_pet(:idx, :name,:species,:owner_idx,:color_idx);",
    "delete_pet" => "SET @idx = (SELECT MAX(idx) FROM `pet`); CALL delete_pet(@idx);",
    "read_owners_pets" => "CALL read_owners_pets(:idx);",
    "find_reminder_pets" => "CALL find_reminder_pets();"
);

$nameRand = "Diego." . rand(100, 255);

$params = array(
    "GetAll" => array(),
    "create_pet" => array(':name' => 'Bob', ':species' => 'Lizard', ':owner_idx' => 1, ':color_idx' => 5),
    "read_pet" => array(':idx' => 4),
    "update_pet" => array(':idx' => 4, ':name' => $nameRand, ':species' => "Cat", ":owner_idx" => 3, ":color_idx" => 2),
    "delete_pet" => array(),
    "read_owners_pets" => array(':idx' => 2),
    "find_reminder_pets" => array(),
);

$testResults = array();

foreach ($queries as $key => $value) {
    $testResult = runTest($value, $params[$key], $key);
    array_push($testResults, $testResult);
}

Header("Content-Type: application/json; charset=utf-8");
exit(json_encode($testResults));
