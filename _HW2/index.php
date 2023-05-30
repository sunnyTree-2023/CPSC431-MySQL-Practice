<?php

?>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>CPSC431 Homework 2 App</title>
    <style>
        body {
            color: black;
        }

        #TestResults {
            table-layout: fixed;
            width: 98%;
            margin: 10px;

        }

        #TestResults tr {
            background-color: #DDD;

        }

        #TestResults td,
        #TestResults th {
            padding: 3px;
        }

        button {
            cursor: pointer;
        }
    </style>
</head>

<body>
    <header>
        <h1>CPSC431-01 Homework 2 App</h1>
        <p>
            Enter the database name. Import the database
            if it does not exist or simply run the tests.
        </p>
    </header>
    <main>
        <form>
            <section>
                <h2>Database Name</h2>
                <input name="dbname" id="dbname" type="text" size="20" maxlength="255" placeholder="DB Name">
            </section>
            <section>
                <h2>Run tests</h2>
                <button type="button" data-action="runTests">Run</button>
            </section>
        </form>
        <section>
            <h2>Test Results...</h2>
            <table id="TestResults">
                <thead>
                    <tr>
                        <th style="width:200px;">Test</th>
                        <th>Result</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="2">No Test Run Yet</td>
                    </tr>
                </tbody>
                </div>
        </section>
    </main>
    <script>
        const actions = {
            runTests: async () => {

                let dbName = document.getElementById("dbname").value;

                let test = await fetch(`api/test.php?db=${dbName}`);

                let json = await test.json();

                window.results = json;

                let output = "";

                json.forEach((el) => {
                    for (const prop in el) {

                        let target = el[prop];
                        let text = target;
                        if (typeof target === "object") {
                            text = JSON.stringify(target);
                        }

                        output += `<tr><td>${prop}</td><td>${text}</td></tr>`;
                    };
                });

                document.querySelector("#TestResults tbody").innerHTML = output;

            }
        };
        document.body.addEventListener("click", (e) => {
            let action = e.target.dataset?.action ?? null;

            actions[action]?.(e);
        });
    </script>
</body>

</html>