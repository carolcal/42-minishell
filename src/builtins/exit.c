/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   exit.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cayamash <cayamash@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/14 15:58:46 by cayamash          #+#    #+#             */
/*   Updated: 2025/03/20 10:56:09 by cayamash         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minishell.h"

int	big_exit_num(int num)
{
	while (num > 255)
		num = num % 256;
	return (num);
}

int	negative_exit_num(int num)
{
	while (num < 0)
		num = num + 256;
	return (num);
}

int	exec_exit(t_data *minishell, char **args)
{
	int		exit_num;
	char	*arg_trim;

	(void) minishell;
	exit_num = 0;
	printf("exit\n");
	if (args[1])
	{
		arg_trim = ft_strtrim(args[1], " ");
		if (!ft_isnum(arg_trim) || skip_zeros(arg_trim) > 18)
			exit_num = print_error(NUMERIC_ARG, 2, "exit", arg_trim);
		else if (args[2])
			return (print_error(EXCEED_ARG, 1, "exit", NULL));
		else
		{
			exit_num = ft_atoi(arg_trim);
			if (exit_num < 0)
				exit_num = negative_exit_num(exit_num);
			else if (exit_num > 255 || exit_num < 0)
				exit_num = big_exit_num(exit_num);
		}
		update_exit_status(minishell, exit_num);
	}
	finish(minishell);
	return (exit_num);
}
