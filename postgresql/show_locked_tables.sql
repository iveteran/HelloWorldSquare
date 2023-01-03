-- 查询所有被锁的表
select t1.locktype, t1.database, t1.pid, t1.mode, t1.relation, t2.relname
from pg_locks t1
join pg_class t2 on t1.relation = t2.oid;

-- 杀掉进程
select pg_terminate_backend('pid')
