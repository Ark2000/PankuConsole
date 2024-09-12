#@tool
#extends EditorScript
class_name PankuPriorityQueue

var heap = []

func is_empty():
	return heap.is_empty()

func size():
	return heap.size()

func push(item, priority):
	heap.push_back([priority, item])
	_sift_up(heap.size() - 1)

func pop():
	if is_empty():
		return null
	
	var result = heap[0][1]
	var last = heap.pop_back()
	
	if not is_empty():
		heap[0] = last
		_sift_down(0)
	
	return result

func peek():
	return heap[0][1] if not is_empty() else null

func _sift_up(index):
	var item = heap[index]
	var parent_index = (index - 1) / 2
	
	while index > 0 and item[0] < heap[parent_index][0]:
		heap[index] = heap[parent_index]
		index = parent_index
		parent_index = (index - 1) / 2
	
	heap[index] = item

func _sift_down(index):
	var item = heap[index]
	var size = heap.size()
	
	while true:
		var min_child = index
		var left_child = 2 * index + 1
		var right_child = 2 * index + 2
		
		if left_child < size and heap[left_child][0] < heap[min_child][0]:
			min_child = left_child
		
		if right_child < size and heap[right_child][0] < heap[min_child][0]:
			min_child = right_child
		
		if min_child == index:
			break
		
		heap[index] = heap[min_child]
		index = min_child
	
	heap[index] = item

# Test function
func test_priority_queue():
	print("Starting Priority Queue test...")
	
	var pq = PankuPriorityQueue.new()
	
	# Test empty queue
	assert(pq.is_empty(), "Newly created queue should be empty")
	assert(pq.size() == 0, "Newly created queue should have size 0")
	assert(pq.pop() == null, "Popping from an empty queue should return null")
	
	# Add elements
	pq.push("Task A", 3)
	pq.push("Task B", 1)
	pq.push("Task C", 2)
	
	assert(not pq.is_empty(), "Queue should not be empty after adding elements")
	assert(pq.size() == 3, "Queue size should be 3")
	
	# Test peek
	assert(pq.peek() == "Task B", "Peek should return the highest priority element")
	assert(pq.size() == 3, "Peek should not change the queue size")
	
	# Test popping by priority
	assert(pq.pop() == "Task B", "Should first pop Task B with priority 1")
	assert(pq.pop() == "Task C", "Should then pop Task C with priority 2")
	assert(pq.pop() == "Task A", "Should finally pop Task A with priority 3")
	
	assert(pq.is_empty(), "Queue should be empty after popping all elements")
	assert(pq.size() == 0, "Queue size should be 0 after popping all elements")
	
	print("Priority Queue test completed!")

# Run the test
func _run():
	test_priority_queue()
