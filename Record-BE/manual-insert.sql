-- ============================================
-- 수동 데이터 삽입 스크립트
-- 친구 추가 및 좋아요 추가
-- ============================================

-- ============================================
-- 1. 친구 추가 (Friendship)
-- ============================================

-- 친구 요청 보내기 (PENDING 상태)
-- user_id: 요청을 보내는 사용자 ID
-- friend_id: 요청을 받는 사용자 ID
-- status: 'PENDING' (대기 중), 'ACCEPTED' (수락됨), 'REJECTED' (거절됨)

-- 예시 1: 사용자 'user1'이 'user2'에게 친구 요청 보내기 (대기 중)
INSERT INTO friendships (user_id, friend_id, status, created_at, updated_at)
VALUES ('user1', 'user2', 'PENDING', NOW(), NOW());

-- 예시 2: 사용자 'user1'과 'user2'가 이미 친구인 경우 (수락됨)
INSERT INTO friendships (user_id, friend_id, status, created_at, updated_at)
VALUES ('user1', 'user2', 'ACCEPTED', NOW(), NOW());

-- 주의사항:
-- 1. user_id와 friend_id는 users 테이블에 존재하는 사용자 ID여야 합니다.
-- 2. 같은 사용자에게 중복 요청을 보낼 수 없습니다 (UNIQUE 제약 조건 확인 필요).
-- 3. 양방향 친구 관계를 만들려면 양쪽 모두 INSERT 해야 합니다:
--    - user1 -> user2 (ACCEPTED)
--    - user2 -> user1 (ACCEPTED)

-- 양방향 친구 관계 생성 예시
INSERT INTO friendships (user_id, friend_id, status, created_at, updated_at)
VALUES 
  ('user1', 'user2', 'ACCEPTED', NOW(), NOW()),
  ('user2', 'user1', 'ACCEPTED', NOW(), NOW());


-- ============================================
-- 2. 좋아요 추가 (TicketLike)
-- ============================================

-- 티켓에 좋아요 추가
-- ticket_id: 좋아요를 누를 티켓 ID (tickets 테이블에 존재해야 함)
-- user_id: 좋아요를 누르는 사용자 ID (users 테이블에 존재해야 함)

-- 예시: 사용자 'user1'이 티켓 ID 1에 좋아요 추가
INSERT INTO ticket_likes (ticket_id, user_id, created_at)
VALUES (1, 'user1', NOW());

-- 여러 사용자가 같은 티켓에 좋아요 추가
INSERT INTO ticket_likes (ticket_id, user_id, created_at)
VALUES 
  (1, 'user1', NOW()),
  (1, 'user2', NOW()),
  (1, 'user3', NOW());

-- 주의사항:
-- 1. ticket_id는 tickets 테이블에 존재하는 티켓 ID여야 합니다.
-- 2. user_id는 users 테이블에 존재하는 사용자 ID여야 합니다.
-- 3. 같은 사용자가 같은 티켓에 중복 좋아요를 누를 수 없습니다 (UNIQUE 제약 조건).


-- ============================================
-- 3. 유용한 조회 쿼리
-- ============================================

-- 현재 사용자 목록 확인
SELECT id, nickname, email FROM users;

-- 현재 티켓 목록 확인
SELECT id, performance_title, user_id FROM tickets;

-- 특정 사용자의 친구 목록 확인
SELECT 
  f.id,
  f.user_id,
  u1.nickname AS requester_nickname,
  f.friend_id,
  u2.nickname AS friend_nickname,
  f.status,
  f.created_at
FROM friendships f
JOIN users u1 ON f.user_id = u1.id
JOIN users u2 ON f.friend_id = u2.id
WHERE f.user_id = 'user1' OR f.friend_id = 'user1';

-- 특정 티켓의 좋아요 개수 확인
SELECT 
  t.id AS ticket_id,
  t.performance_title,
  COUNT(tl.id) AS like_count
FROM tickets t
LEFT JOIN ticket_likes tl ON t.id = tl.ticket_id
WHERE t.id = 1
GROUP BY t.id, t.performance_title;

-- 특정 티켓에 좋아요를 누른 사용자 목록
SELECT 
  tl.id,
  tl.ticket_id,
  u.id AS user_id,
  u.nickname,
  tl.created_at
FROM ticket_likes tl
JOIN users u ON tl.user_id = u.id
WHERE tl.ticket_id = 1;


-- ============================================
-- 4. 데이터 삭제 (필요시)
-- ============================================

-- 친구 관계 삭제
DELETE FROM friendships 
WHERE user_id = 'user1' AND friend_id = 'user2';

-- 좋아요 삭제
DELETE FROM ticket_likes 
WHERE ticket_id = 1 AND user_id = 'user1';

