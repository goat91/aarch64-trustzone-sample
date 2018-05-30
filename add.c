
static int result;
int sum = 3;

int add(int a, int b) {
	int c = a - b;

	result = a + b;

	sum += a - b;
	return a + b + c;
}
