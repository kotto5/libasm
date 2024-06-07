#include <stdio.h>
#include <string.h>
#include <stdbool.h>

extern size_t ft_strlen(const char *s);

static bool ft_isspace(char c) {
	return (c == ' ' || c == '\t' || c == '\n' || c == '\v' || c == '\f' || c == '\r');
}

static const char *get_initial_portion(const char *s) {
	size_t i = 0;    
	while (ft_isspace(s[i]))
		i++;
	return &s[i];
}

static int get_sign(const char *s) {
	if (s[0] == '-') {
		return -1;
	} else {
		return 1;
	}
}

int			ft_atoi_base(const char *str, char *base)
{
	if (str == NULL || !*str || base == NULL || ft_strlen(base) <= 1)
		return (0);

    ssize_t base_len = ft_strlen(base);

	const char *initial_portion = get_initial_portion(str);
	if (ft_strlen(initial_portion) == 0)
		return 0;
	
	int sign = get_sign(initial_portion);
	if (*initial_portion == '-' || *initial_portion == '+')
		initial_portion++;

	int sum = 0;
	size_t i = 0;
	char *found = NULL;
	while ((found = strchr(base, initial_portion[i])))
	{
		sum = sum * base_len + (found - base);
		i++;
	}
	return (sign * sum);
}
