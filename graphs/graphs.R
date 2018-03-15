pacman::p_load(rvest, qdap, dplyr, data.table, ggplot2)

#r = list()
#dims = c()
#sizes = c(1, 100, 1000, 10000, 20000, 200000)

#for(i in 1:length(sizes)) {
#        N = sizes[i]
#        ds1 = data.frame(id = rep(LETTERS, N), c1 = rnorm(26*N))
#        ds2 = data.frame(id = rep(LETTERS[1:10], 10), c2 = runif(10, 10, 20))
#        
#        ds1$id = as.character(ds1$id)
#        ds2$id = as.character(ds2$id)
#        
#        dsBase = system.time(m1 <- base::merge(x = ds1, ds2, by = 'id', all.x = FALSE, all.y = TRUE))[3]
#        dsDplry = system.time(m2 <- ds1 %>% 
#                                      right_join(ds2, by='id'))[3]
#        dsData.table = system.time(m3 <- merge(data.table(ds1), data.table(ds2), by = 'id', all.x = FALSE, all.y = TRUE, allow.cartesian = TRUE))[3]
#        
#        r[[i]] = data.frame('base r' = dsBase, 'dplyr' = dsDplry, 'data.table' = dsData.table, dim = dim(m1)[1])
#}
#
#
#d = rbindlist(r) %>% melt(id.vars = c('dim'))

saveRDS(d, filename = 'plotdata.rds')

plot = ggplot(data = plotdata) + geom_line(aes(x=dim, y = value, colour = variable, group = variable), size=1.5, alpha = 0.8) +
        ylab('seconds\n') + 
        xlab('\nrows in final database')  +
        scale_colour_discrete(name = '') + 
        theme(legend.position = 'top')

ggsave(plot, filename = 'graphs/benchmark.png', width = 3.5, height = 2.5)


