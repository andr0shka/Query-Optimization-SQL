# Query-Optimization-SQL

## Опис завдання

У цьому завданні потрібно оптимізувати SQL-запит, що рахує email-метрики в розрізі операційних систем.

## Вимоги до оптимізації
- Покращити продуктивність запиту, мінімізуючи витрати ресурсів.
- Звернути увагу на `EXECUTION DETAILS` до та після оптимізації.
- Зафіксувати зміни у продуктивності та прикріпити скріншоти ключових параметрів.
- Надати код оптимізованого запиту.

## Початковий SQL-запит
```sql
SELECT
    account_session.operating_system,
    COUNT(DISTINCT id_message_sent) AS sent_msg,
    COUNT(DISTINCT id_message_open) AS open_msg,
    COUNT(DISTINCT id_message_visit) AS visit_msg,
    COUNT(DISTINCT id_message_open) / COUNT(DISTINCT id_message_sent) * 100 AS open_rate,
    COUNT(DISTINCT id_message_visit) / COUNT(DISTINCT id_message_sent) * 100 AS click_rate,
    COUNT(DISTINCT id_message_visit) / COUNT(DISTINCT id_message_open) * 100 AS ctor
FROM
    `DA.account` a
JOIN (
    SELECT
        es.id_account AS id_account_sent,
        es.id_message AS id_message_sent,
        eo.id_message AS id_message_open,
        ev.id_message AS id_message_visit
    FROM
        `DA.email_sent` es
    LEFT JOIN `DA.email_open` eo ON es.id_message = eo.id_message
    LEFT JOIN `DA.email_visit` ev ON es.id_message = ev.id_message
) email_sent
ON a.id = email_sent.id_account_sent
JOIN (
    SELECT
        acs.account_id,
        sp.operating_system
    FROM
        `DA.account_session` acs
    JOIN `DA.session_params` sp ON acs.ga_session_id = sp.ga_session_id
) account_session
ON a.id = account_session.account_id
WHERE
    a.is_unsubscribed = 0
GROUP BY
    account_session.operating_system;
```

