--Adding sql code 
-- This is code for consecutive missed sessions
WITH consecutive_missed_sessions AS (
 SELECT UserID, SessionDate,
 CASE WHEN LAG(IsCompleted, 1, 1) OVER (PARTITION BY UserID ORDER BY SessionDate) = 0
 THEN 1
 ELSE 0
 END AS missed_session,
 SUM(CASE WHEN LAG(IsCompleted, 1, 1) OVER (PARTITION BY UserID ORDER BY SessionDate) = 0
 THEN 1
 ELSE 0
 END) OVER (PARTITION BY UserID ORDER BY SessionDate) AS consecutive_missed
 FROM WorkoutSessions
)
SELECT DISTINCT UserID
FROM consecutive_missed_sessions
WHERE consecutive_missed > 5 AND IsCompleted = 0;