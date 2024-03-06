DROP TABLE IF EXISTS tb_seller_sgmt;
CREATE TABLE tb_seller_sgmt AS 

SELECT T1.*,
        CASE WHEN pct_receita <= 0.5 AND pct_freq <= 0.5 THEN 'BAIXO V. BAIXO F.'
        WHEN pct_receita > 0.5 AND pct_freq <= 0.5 THEN 'ALTO VALOR'
        WHEN pct_receita <= 0.5 AND pct_freq > 0.5 THEN 'ALTA FREQ'
        WHEN pct_receita < 0.9 OR pct_freq < 0.9 THEN 'PRODUTIVO'
        ELSE 'SUPER PRODUTIVO' END AS SEGMENTO_VALOR_FREQ 

FROM (

   SELECT T1.*,
        percent_rank() over (order by receita_total asc) as pct_receita,
        percent_rank() over (order by qtde_pedidos asc) as pct_freq

    FROM (

        SELECT  T2.seller_id,
                SUM( T2.price )  AS receita_total,
                COUNT( DISTINCT T1.order_id ) as qtde_pedidos,
                COUNT( T2.product_id ) as qtde_produtos,
                COUNT( DISTINCT T2.product_id ) as qtde_produtos,
                MIN(CAST(julianday('2018-06-01') - julianday(T1.order_approved_at) AS INT)) AS qtde_dias_ult_venda,
                MAX(CAST(julianday('2018-06-01') - julianday(t3.dt_inicio) AS INT)) AS qtde_dias_base
            

        FROM tb_orders AS T1

        LEFT JOIN tb_order_items as T2
        ON T1.order_id=T2.order_id

        LEFT JOIN (
            SELECT T2.seller_id,
                    MIN(DATE(T1.order_approved_at ))  AS dt_inicio
            
            FROM tb_orders AS T1
            LEFT JOIN tb_order_items as T2
            ON T1.order_id=T2.order_id
            
            GROUP BY T2.seller_id
        ) AS T3
        ON T2.seller_id=t3.seller_id


        WHERE T1.order_approved_at BETWEEN '2017-06-01' AND '2018-06-01'

        GROUP BY T2.seller_id ) AS T1
) AS T1
;