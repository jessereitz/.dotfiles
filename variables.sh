# Set up weird python path stuff for Mackerel
export CODE_HOME=~/ordoro
export PYTHONPATH=${CODE_HOME}/mackerel/conf:${CODE_HOME}/mackerel/supplier-feeds:${CODE_HOME}/whistlepig/2.0/lib:${CODE_HOME}/mackerel/lib/
export MACKEREL_HOME=${CODE_HOME}/mackerel
export MACKEREL_ENV='DEV'

export JESSE_CO=563955
export ORDORO_CO=563955
export ORDORO_SUPPLIER=43532
export ORDORO_CART=100516
export ORDORO_LOCATION=62055

export ORDORO_CSP_PATH=/Users/jessereitz/Bonnie/cloud_sql_proxy
export ORDORO_DB_CONNECTIONS=(
    "db slave prod 5433"
    "db task prod 5440"
    "db mackerel prod 5489"
    "db whistlepig prod 5435"
    "db audit dev 5476"
    "db audit prod 5477"
    "db master dev 5469"
    "db task dev 5471"
    "ebenezer master dev 5478"
    "ebenezer master prod 5479"
)


