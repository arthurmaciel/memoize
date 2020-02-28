
(cond-expand
 (chicken-4
  (use test memoize))
 (chicken-5
  (import test)
  (import memoize)))

(define (fact x)
  (let loop ((x x) (acc 1))
    (if (= x 0)
	acc
	(loop (- x 1) (* x acc)))))

(define memo-fact (memoize fact))
(test "Memoizatoin WITHOUT limit" (fact 322) (memo-fact 322))

(define memo-fact (memoize fact 3))
(memo-fact 320) 
(memo-fact 321) 
(memo-fact 322) 
(test "Memoizatoin WITH limit" (fact 323) (memo-fact 323))

(test-exit)
