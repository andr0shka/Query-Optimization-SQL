-- Попередній фільтр таблиці account_session і session_params для оптимізації
WITH filtered_sessions AS (
  SELECT
    acs.account_id,
    sp.operating_system
  FROM
    `DA.account_session` acs
  JOIN
    `DA.session_params` sp ON acs.ga_session_id = sp.ga_session_id
  WHERE
    sp.operating_system IS NOT NULL
)


SELECT
  sp.operating_system,
  COUNT(DISTINCT es.id_message) AS sent_msg,
  COUNT(DISTINCT eo.id_message) AS open_msg,
  COUNT(DISTINCT ev.id_message) AS visit_msg,
  SAFE_DIVIDE(COUNT(DISTINCT eo.id_message), COUNT(DISTINCT es.id_message)) * 100 AS open_rate,
  SAFE_DIVIDE(COUNT(DISTINCT ev.id_message), COUNT(DISTINCT es.id_message)) * 100 AS click_rate,
  SAFE_DIVIDE(COUNT(DISTINCT ev.id_message), COUNT(DISTINCT eo.id_message)) * 100 AS ctor
FROM
  `DA.email_sent` es
LEFT JOIN `DA.email_open` eo ON es.id_message = eo.id_message
LEFT JOIN `DA.email_visit` ev ON es.id_message = ev.id_message
JOIN filtered_sessions sp ON es.id_account = sp.account_id
JOIN `DA.account` a ON es.id_account = a.id
WHERE
  a.is_unsubscribed = 0
GROUP BY
  sp.operating_system
