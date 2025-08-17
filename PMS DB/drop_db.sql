UPDATE pg_database SET datallowconn = 'false' WHERE datname = 'PMS';
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'PMS';
DROP DATABASE IF EXISTS PMS;
DROP USER IF EXISTS postgres;
