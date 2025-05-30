/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   parser.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: naharumi <naharumi@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/03/12 19:53:56 by naharumi          #+#    #+#             */
/*   Updated: 2025/04/08 17:23:12 by naharumi         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minishell.h"

t_ast	*new_node(int id)
{
	t_ast	*node;

	node = allocate_mem(1, sizeof(t_ast));
	if (!node)
		handle_error(MALLOC);
	node->id = id;
	node->args = NULL;
	node->left = NULL;
	node->right = NULL;
	return (node);
}

void	free_ast(t_ast *node)
{
	if (!node)
		return ;
	free_ast(node->left);
	free_ast(node->right);
	ft_free_arr(node->args);
	deallocate_mem(node);
}

t_ast	*build_tree(t_data *minishell, t_token *tokens)
{
	t_token	*op;

	if (is_subshell(tokens))
		return (parse_subshell(minishell, tokens));
	op = search_and_or(tokens);
	if (op)
		return (parse_operators(minishell, tokens, op));
	op = search_pipe(tokens);
	if (op)
		return (parse_operators(minishell, tokens, op));
	op = search_redir(tokens);
	if (op)
		return (parse_redir(minishell, tokens, op));
	return (parse_token(tokens));
}
