# Heatmap of rg and MR results
library(extrafont)
loadfonts()
text_size = 5
theme.size = 1.25
astrix.size = 2
line.size = 0.25

dat.long = dat.long %>% 
  mutate(method = fct_recode(method, "rg" = "Genetic \nCorrelation", "MR" = "Mendelian \nRandomization"), 
         domain.exposure = fct_relevel(domain.exposure, "Risk factor", "Biomarker", 'Disease liability'))


p3 <- ggplot(dat.long) +
  facet_grid(method ~ domain.exposure, scales = "free", space = "free", switch = "y") +
  # geom_raster(data = filter(dat.long, !is.na(rg)), aes(x = exposure.name, y = outcome.name, fill = rg)) +
  geom_tile(data = filter(dat.long, !is.na(rg)),
            aes(x = exposure.name, y = outcome.name, fill = rg, height=rg.p_cat, width=rg.p_cat)) +
  geom_text(data = filter(dat.long, !is.na(rg)),
            aes(label = rg.fdr_signif, x = exposure.name, y = outcome.name), vjust = 0.75, size = astrix.size) +
  scale_fill_distiller(palette = rev(the_palette), limits = c(-1,1)) +
  new_scale("fill") +
  # geom_raster(data = filter(dat.long, !is.na(mr)), aes(x = exposure.name, y = outcome.name, fill = mr)) +
  geom_tile(data = filter(dat.long, !is.na(mr)),
            aes(x = exposure.name, y = outcome.name, fill = mr, height=mr.p_cat, width=mr.p_cat)) +
  scale_fill_distiller(palette = rev(the_palette), limits = c(-6,6)) +
  geom_text(data = filter(dat.long, !is.na(mr)),
            aes(label = fdr_signif, x = exposure.name, y = outcome.name), vjust = 0.75, size = astrix.size) +
  theme_classic() +
  geom_vline(xintercept=seq(0.5, 43.5, 1),color="grey90",size=line.size) +
  geom_hline(yintercept=seq(0.5, 11.5, 1),color="grey90",size=line.size) +
  theme(legend.position = 'none',
        axis.text.x = element_text(angle = 35, hjust = 0),
        aspect.ratio=1,
        legend.text = element_text(hjust = 1.5),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.margin=margin(10,40,10,10, 'pt'),
        text = element_text(size=text_size, family="Arial"),
        strip.text.y = element_text(size = text_size, family="Arial"),
        axis.ticks = element_line(size = line.size),
        axis.line = element_line(size = line.size),
        strip.background = element_blank(),
        # panel.border = element_rect(colour = "black", fill = NA)
        # legend.key.height = unit(0.75, "line"),
        # legend.spacing.y = unit(-0.75, "line"),
        # plot.margin=grid::unit(c(0,0,0,0), "mm")
  ) +
  scale_x_discrete(position = "top") +
  ylim(rev(levels(dat.long$outcome.name)))
p3

## Use geom_point to hack togeather a legend
point.size = 0.25
arrow.size = 1

p.leg <- ggplot(df, aes(x = x, y = y, color = as.factor(x))) +
  geom_point(size = point.size, shape = 15) +
  scale_color_manual(values = my_colors) +
  theme_void() +
  theme(legend.position = 'none') +
  annotate("segment", x = -50, y = 0.95, xend = -500, yend = 0.95,  size = line.size,
           arrow=arrow(length=unit(arrow.size,"pt"), type = "closed")) +
  annotate("segment", x = 50, y = 0.95, xend = 500, yend = 0.95, size = line.size,
           arrow=arrow(length=unit(arrow.size,"pt"), type = "closed")) +
  annotate("text", x = -440, y = 0.90, label = "Negative/Protective", size = theme.size) +
  annotate("text", x = 460, y = 0.90, label = "Positive/Risk", size = theme.size) +
  annotate("text", x = 0, y = 0.90, label = "rg/MR", size = theme.size) +
  theme(legend.position = 'none',
        # aspect.ratio=1/10,
        text = element_text(size=text_size, family="Arial"),
        plot.margin=margin(0,0,0,0, 'pt'),
  ) +
  expand_limits(y = c(0.8, 1.1))

## Put some padding around the legend
p.leg_out2 <- ggarrange(ggblank, p.leg, ggblank,
                        nrow = 1, ncol = 3, widths = c(0.137, 1, 0.033))

## combine heatmap and legend
p.heatmap2 <- ggarrange(
  p3 + theme(plot.margin = margin(0, 0.75, -1, 0, "cm")), 
  p.leg_out2,
  nrow = 2, ncol = 1, heights = c(1,0.15)) 

ggsave(glue("~/Downloads/{model}_MR_RGheatmap.png"), plot = p.heatmap2, width = 11.5, height = 5, units = "cm")
ggsave(glue("~/Downloads/{model}_MR_RGheatmap.pdf"), plot = p.heatmap2, width = 11.5, height = 5, units = "cm")
ggsave(glue("~/Downloads/{model}_MR_RGheatmap.tiff"), plot = p.heatmap2, width = 11.5, height = 5, units = "cm")
