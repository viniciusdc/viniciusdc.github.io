```python
def get_latest_version(
    name: str, payload_meta_yaml: Any, sources: Iterable[AbstractSource]
):
    with payload_meta_yaml as meta_yaml:
        for source in sources:
            logger.debug("source: %s", source.__class__.__name__)
            url = source.get_url(meta_yaml)
            logger.debug("url: %s", url)
            if url is None:
                continue
            ver = source.get_version(url)
            logger.debug("ver: %s", ver)
            if ver:
                return ver
            else:
                meta_yaml["bad"] = f"Upstream: Could not find version on {source.name}"
        if not meta_yaml.get("bad"):
            meta_yaml["bad"] = "Upstream: unknown source"
        return False


def _update_upstream_versions_sequential(
    gx: nx.DiGraph, sources: Iterable[AbstractSource],
) -> None:
    _all_nodes = [t for t in gx.nodes.items()]
    random.shuffle(_all_nodes)

    to_update = []
    for node, node_attrs in _all_nodes:
        attrs = node_attrs["payload"]
        if attrs.get("bad") or attrs.get("archived"):
            attrs["new_version"] = False
            continue
        to_update.append((node, attrs))

    for node, node_attrs in to_update:
        with node_attrs as attrs:
            try:
                new_version = get_latest_version(node, attrs, sources)
                attrs["new_version"] = new_version or attrs["new_version"]
            except Exception as e:
                try:
                    se = repr(e)
                except Exception as ee:
                    se = f"Bad exception string: {ee}"
                logger.warning(f"Error getting uptream version of {node}: {se}")
                attrs["bad"] = "Upstream: Error getting upstream version"
            else:
                logger.info(
                    f"{node} - {attrs.get('version')} - {attrs.get('new_version')}",
                )


def update_upstream_versions(
    gx: nx.DiGraph, sources: Iterable[AbstractSource] = None,
) -> None:
    sources = (
        (PyPI(), CRAN(), NPM(), ROSDistro(), RawURL(), Github())
        if sources is None
        else sources
    )
    updater = (
        _update_upstream_versions_sequential
        if CONDA_FORGE_TICK_DEBUG
        else _update_upstream_versions_process_pool
    )
    logger.info("Updating upstream versions")
    updater(gx, sources)


def main(args: Any = None) -> None:
    if CONDA_FORGE_TICK_DEBUG:
        setup_logger(logger, level="debug")
    else:
        setup_logger(logger)

    logger.info("Reading graph")
    gx = load_graph()

    update_upstream_versions(gx)

    logger.info("writing out file")
    dump_graph(gx)
```
